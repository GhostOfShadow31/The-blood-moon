extends Node2D

@export var quest: Node2D

@onready var talk_zone = $TalkZone
@onready var bubble = $Bubble

signal start_new_dialogue(index: int)

var player_in_range: bool = false

func _ready() -> void:
	# On arrête et on cache l'animation de la bulle
	bubble.visible = false
	bubble.stop()
	
	# On connecte les signaux
	talk_zone.body_entered.connect(on_body_entered)
	talk_zone.body_exited.connect(on_body_exited)
	if quest == null:
		push_warning("Le pnj ne possède pas de quête")
		set_process(false)
		return

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_accept") and not Inventaire.is_inventory_active:
		if StoryManager.is_playing:
			DialogueUi.advance_or_close()
		else:
			if quest.step == 0 or not quest.is_arene_visited:
				emit_signal("start_new_dialogue", 19)
				quest.advance_step()
			elif quest.step >= 1 and quest.step < quest.step_max and quest.is_arene_visited:
				emit_signal("start_new_dialogue", 20)
				if quest.step == 1:
					quest.advance_step()
			elif quest.step == quest.step_max:
				print("La qiête est finie, je peux agir normalement")

# Action à faire quand un joueur rentre dans la TalkZone
func on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Le joueur peut parler
		player_in_range = true
		# Animation de la bulle
		bubble.visible = true
		bubble.play("default")

# Action à faire quand un joueur quitte la TalkZone
func on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		# Le joueur ne peut plus parler
		player_in_range = false
		# On arrête et on cache l'animation de la bulle
		bubble.visible = false
		bubble.stop()
