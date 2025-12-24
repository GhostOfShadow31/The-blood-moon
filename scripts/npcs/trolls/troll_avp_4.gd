extends Node2D

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

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_accept") and not Inventaire.is_inventory_active:
		if StoryManager.is_playing:
			DialogueUi.advance_or_close()
		else:
			emit_signal("start_new_dialogue", 18)

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
