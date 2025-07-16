extends Node2D

@onready var sprite = $BubbleQuestion

signal start_new_dialogue(index: int)

var player_in_range = false

func _ready() -> void:
	sprite.visible = false
	sprite.stop()
	
	# On connecte les signaux
	StoryManager.step_finished.connect(_on_dialogue_ended)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		if StoryManager.is_playing:
			DialogueUi.advance_or_close()
		else:
			call_deferred("_start_monologue")

# Démarre le monologue du héro
func _start_monologue():
	emit_signal("start_new_dialogue", 2)

# Quand le joueur rentre dans la zone pour parler
func _on_secret_space_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		sprite.visible = true
		sprite.play("default")
		player_in_range = true

# Quand le joueur sort de la zone pour parler
func _on_secret_space_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		sprite.visible = false
		sprite.stop()
		player_in_range = false

# Quand le dialogue se termine
func _on_dialogue_ended(who: String):
	if who != "Hero":
		return
	
	await get_tree().create_timer(0.2).timeout
