extends Node2D

@onready var bubble_animated = $Pancarte_animated/TalkZone/Bubble
@onready var talk_zone = $Pancarte_animated/TalkZone

signal start_new_dialogue(index: int)

var player_in_range = false # Définit quand le joueur peut parler à la pancarte

func _ready() -> void:
	# On ne vois pas la bulle au démarrage
	bubble_animated.stop()
	bubble_animated.visible = false
	
	talk_zone.body_entered.connect(_on_body_entered)
	talk_zone.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_accept") and not Inventaire.is_inventory_active:
		if not StoryManager.is_playing:
			start_dialogue()
		else:
			DialogueUi.advance_or_close()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Quand le joueur entre, on affiche la bulle
		bubble_animated.play("default")
		bubble_animated.visible = true
		player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	# Quand le joueur sort, on cache la bulle
	if body.name == "Player":
		bubble_animated.stop()
		bubble_animated.visible = false
		player_in_range = false

func start_dialogue():
	# On veut démarrer un dialogue
	var name_as_string: String = name.split("_")[1]
	var index: int = int(name_as_string) - 1
	emit_signal("start_new_dialogue", index)
