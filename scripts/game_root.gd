extends Node

@export var intro_scene: PackedScene
@export var cave_scene: PackedScene
@export var hero_scene: PackedScene

@onready var world_root: Node2D = $WorldRoot
@onready var overlay: ColorRect = $UIRoot/FadeOverlay
@onready var dialogue_ui: DialogueUI = $UIRoot/DialogueUI

var intro_instance: Node2D
var cave_instance: Node2D
var hero_instance: Node2D

func _ready() -> void:
	start_game()

func start_game() -> void:
	# Intro
	intro_instance = intro_scene.instantiate()
	world_root.add_child(intro_instance)
	
	# Cave (cachée)
	cave_instance = cave_scene.instantiate()
	cave_instance.visible = false
	world_root.add_child(cave_instance)
	
	# Hero (désactivé)
	hero_instance = hero_scene.instantiate()
	hero_instance.visible = false
	hero_instance.set_process(false)
	world_root.add_child(hero_instance)
	
	# Connexion signal intro -> fin
	intro_instance.intro_finished.connect(_on_intro_finished)
	intro_instance.request_dialogue_ui.connect(_on_request_dialogue_ui)
	intro_instance.request_fade_in_out.connect(_on_request_fade_in_out)

func _on_intro_finished() -> void:
	# Netoyage de l'intro
	intro_instance.queue_free()
	
	# Activation du monde
	cave_instance.visible = true
	
	hero_instance.visible = true
	hero_instance.set_process(true)
	hero_instance.set_physics_process(true)
	
	# Placement du héro
	hero_instance.global_position = Vector2(274, 148)

func _on_request_fade_in_out(duration_fade: float, duration_active: float) -> void:
	overlay.fade_in_out(duration_fade, duration_active)

func _on_request_dialogue_ui(dialogues: Array) -> void:
	dialogue_ui.start_dialogue(dialogues)
