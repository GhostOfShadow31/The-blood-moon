extends Node2D

@export var quest_node: Node

@onready var bubble = $Bubble
@onready var talk_zone = $TalkZone

signal start_new_dialogue(quest_name: String, index: int)

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
				
				if found_index == quest_node.step: # C'est son tour
					quest_node.advance()
				elif found_index < quest_node.step and quest_node.steps.size() != quest_node.max_step: # Il est déjà passé, il répète
					quest_node.repeat(found_index)
				elif quest_node.steps.size() == quest_node.max_step:
					print("Cas 1")
			else:
				print("Cas 2")

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
	emit_signal("start_new_dialogue", quest_name, index)
