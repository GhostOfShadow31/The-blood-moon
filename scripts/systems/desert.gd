extends Node2D

@export var node_path_pancartes: NodePath
@export var node_path_pnj: NodePath

@onready var black_screen = $BlackScreen
@onready var pancartes = get_node(node_path_pancartes)
@onready var pnjs = get_node(node_path_pnj)

signal player_position(Vector2)

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
		pnj.start_new_dialogue.connect(play_scene_quest)
	
	black_screen.visible = true
	
	# On envoie l aposition au joueur
	emit_signal("player_position", Vector2(3280, 20))

func _process(delta: float) -> void:
	if black_screen.modulate.a > 0.0:
		black_screen.modulate.a -= fade_speed * delta
		if black_screen.modulate.a < 0.0:
			black_screen.modulate.a = 0.0

func play_scene(index: int):
	print(index)
	StoryManager.play_story(desert_steps, index)

func play_scene_quest(quest_name: String, index: int):
	var real_index: int = index
	match quest_name:
		"PontCasse":
			real_index += 10
		_:
			push_warning("quete inconnue: ", quest_name)
	
	play_scene(real_index)
