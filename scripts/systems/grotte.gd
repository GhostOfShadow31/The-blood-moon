extends Node

@onready var apotre_elfe = get_node("ApotreElfe")
@onready var map_grotte = $MapGrotte

# Liste des étapes du scénario dans la grotte : dialogues et monologues
var grotte_steps = ""

func _ready() -> void:
	# On connecte les signaux
	apotre_elfe.start_new_dialogue.connect(_play_scene)
	apotre_elfe.start_new_cinematic.connect(_play_scene)
	map_grotte.start_new_dialogue.connect(_play_scene)
	var file = FileAccess.open("res://story/storyGrotte.json", FileAccess.READ)
	var content = file.get_as_text()
	grotte_steps = JSON.parse_string(content)

func _play_scene(index: int):
	# On lance la story avec ces étapes
	StoryManager.play_story(grotte_steps, index)
