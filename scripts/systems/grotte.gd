extends Node

@onready var apotre_elfe = get_node("ApotreElfe")
@onready var map_grotte = $MapGrotte
@onready var black_screen = $BlackScreen

# Liste des étapes du scénario dans la grotte : dialogues et monologues
var grotte_steps = ""
var fade_speed = 0.1

func _ready() -> void:
	# On connecte les signaux
	apotre_elfe.start_new_dialogue.connect(_play_scene)
	apotre_elfe.start_new_cinematic.connect(_play_scene)
	map_grotte.start_new_dialogue.connect(_play_scene)
	var file = FileAccess.open("res://story/storyGrotte.json", FileAccess.READ)
	var content = file.get_as_text()
	grotte_steps = JSON.parse_string(content)
	
	black_screen.visible = true

func _process(delta: float) -> void:
	if black_screen.modulate.a > 0.0:
		black_screen.modulate.a -= fade_speed * delta * 3
		if black_screen.modulate.a < 0.0:
			black_screen.modulate.a = 0.0

func _play_scene(index: int):
	# On lance la story avec ces étapes
	StoryManager.play_story(grotte_steps, index)
