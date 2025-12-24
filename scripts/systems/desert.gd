extends Node2D

@export var node_path_pancartes: NodePath
@export var node_path_pnj: NodePath

@onready var black_screen = $BlackScreen
@onready var pancartes = get_node(node_path_pancartes)
@onready var pnjs = get_node(node_path_pnj)

signal player_position(pos: Vector2)

var fade_speed = 0.25
var desert_steps = ""

func _ready() -> void:
	# On va chercher la story associée
	var file = FileAccess.open("res://data/story/storyDesert.json", FileAccess.READ)
	var content = file.get_as_text()
	desert_steps = JSON.parse_string(content)
	
	for pancarte in pancartes.get_children():
		pancarte.start_new_dialogue.connect(play_scene)
	
	for pnj in pnjs.get_children():
		if pnj.name == "Troll_Arene":
			pnj.replace_player.connect(set_player_position)
		elif pnj.name == "Troll_Intermediaire" or pnj.name == "Troll_Verifiable":
			pnj.start_new_cinematique.connect(play_scene)
		pnj.start_new_dialogue.connect(play_scene)
	
	black_screen.visible = true
	
	# On envoie l aposition au joueur
	#set_player_position(Vector2(3280, 20))
	set_player_position(Vector2(2000, 1500))

func _process(delta: float) -> void:
	if black_screen.modulate.a > 0.0:
		black_screen.modulate.a -= fade_speed * delta
		if black_screen.modulate.a < 0.0:
			black_screen.modulate.a = 0.0

func play_scene(index: int):
	StoryManager.play_story(desert_steps, index)

func set_player_position(pos: Vector2) -> void:
	emit_signal("player_position", pos)
