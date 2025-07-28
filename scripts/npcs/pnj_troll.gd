extends Node2D

@export var quest_node: Node

@onready var bubble = $Bubble
@onready var talk_zone = $TalkZone

signal start_new_dialogue(index: int)
signal start_new_dialogue_quest(quest_name: String, index: int)

var player_in_range = false

func _ready() -> void:
	bubble.stop()
	bubble.visible = false
	
	talk_zone.body_entered.connect(_on_body_entered)
	talk_zone.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_accept") and not Inventaire.is_inventory_active:
		if StoryManager.is_playing:
			DialogueUi.advance_or_close()
		else:
			if quest_node:
				var indexes = quest_node.get_indexes_of_pnj(self)
				
				# Prendre l'index qui correspond au step courant ou précédent
				var found_index = -1
				for i in indexes:
					if i == quest_node.step:
						found_index = i
						break
					elif i < quest_node.step:
						found_index = i # Garde le dernier match avant le step
				
				if quest_node.step == quest_node.max_step: # La quête est finie
					print("Cas 1")
				elif found_index == -1: # Le pnj fait parti de la quête mais il n'est ce n'est pas encore sont tour, il fait comme s'il n'avait pas de quête
					var array_name = name.split("_")
					var function_of_pnj = array_name[1]
					start_dialogue(function_of_pnj)
				elif found_index == quest_node.step: # C'est son tour
					quest_node.advance()
				elif found_index < quest_node.step: # Il est déjà passé, il répète
					quest_node.repeat(found_index)
			else: # Il n'a pas de quête
				var array_name = name.split("_")
				var function_of_pnj = array_name[1]
				start_dialogue(function_of_pnj)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		bubble.play("default")
		bubble.visible = true
		
		player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		bubble.stop()
		bubble.visible = false
		
		player_in_range = false

func quest(quest_name: String, index: int) -> void:
	emit_signal("start_new_dialogue_quest", quest_name, index)

func start_dialogue(function: String) -> void:
	var index: int
	match function:
		"Pont":
			pass
		"Scierie":
			index = 13
		"AVP1":
			index = 14
		"AVP2":
			index = 15
		"Arene":
			index = 16
		_:
			push_warning("Fonction du pnj inconnue: ", function)
	emit_signal("start_new_dialogue", index)
