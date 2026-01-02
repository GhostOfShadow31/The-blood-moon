extends Node

@export var intro_scene: PackedScene
@export var cave_scene: PackedScene
@export var hero_scene: PackedScene

@onready var world_root: Node2D = $WorldRoot
@onready var camera: Camera2D = $WorldRoot/Camera2D
@onready var overlay: ColorRect = $UIRoot/FadeOverlay
@onready var dialogue_ui: DialogueUI = $UIRoot/DialogueUI

var intro_instance: Node2D
var cave_instance: Node2D
var hero_instance: Node2D

func _ready() -> void:
	start_intro()
	#start_gameplay()

func start_intro() -> void:
	
	# Intro
	intro_instance = intro_scene.instantiate()
	world_root.add_child(intro_instance)
	
	# On donne l'intro à la caméra
	camera.set_context(intro_instance.get_camera_focus())
	
	# Connexion signal intro -> fin
	intro_instance.intro_finished.connect(start_gameplay)
	intro_instance.request_dialogue_ui.connect(_on_request_dialogue_ui)
	intro_instance.request_fade_in_out.connect(_on_request_fade_in_out)

func start_gameplay() -> void:
	
	# Netoyage de l'intro
	if intro_instance != null:
		intro_instance.queue_free()
	
	# Cave
	cave_instance = cave_scene.instantiate()
	world_root.add_child(cave_instance)
	
	# Hero
	hero_instance = hero_scene.instantiate()
	world_root.add_child(hero_instance)
	
	# Placement du héro
	hero_instance.global_position = Vector2(608, 532)
	
	# On donne le hero à la camera
	camera.set_context(hero_instance)
	
	# Définit les limites de la camera
	var limits: Rect2 = cave_instance.get_camera_bound()
	camera.limit_left = int(limits.position.x)
	camera.limit_top = int(limits.position.y)
	camera.limit_right = int(limits.position.x + limits.size.x)
	camera.limit_bottom = int(limits.position.y + limits.size.y)

func _on_request_fade_in_out(duration_fade: float, duration_active: float) -> void:
	overlay.fade_in_out(duration_fade, duration_active)

func _on_request_dialogue_ui(dialogues: Array) -> void:
	dialogue_ui.start_dialogue(dialogues)
