extends Node

@export var intro_scene: PackedScene
@export var cave_scene: PackedScene
@export var hero_scene: PackedScene

@onready var world_root: Node2D = $WorldRoot
@onready var camera: Camera2D = $WorldRoot/Camera2D

@onready var overlay: ColorRect = $UIRoot/FadeOverlay
@onready var dialogue_ui: DialogueUI = $UIRoot/DialogueUI
@onready var health_ui: Control = $UIRoot/Pv

var intro_instance: Node2D
var cave_instance: Node2D
var hero_instance: Node2D

var current_environnement: Node2D

func _ready() -> void:
	start_intro()
	#start_gameplay()

func start_intro() -> void:
	# On cache ce qui n'est pas essentiel
	health_ui.visible = false
	
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
	
	# Cave
	cave_instance = cave_scene.instantiate()
	world_root.add_child(cave_instance)
	current_environnement = cave_instance
	
	# Hero
	hero_instance = hero_scene.instantiate()
	world_root.add_child(hero_instance)
	
	# Placement du héro
	hero_instance.global_position = Vector2(608, 534)
	
	# On donne le hero à la camera
	camera.set_context(hero_instance)
	
	# Définit les limites de la camera
	var limits: Rect2 = cave_instance.get_camera_bound()
	camera.limit_left = int(limits.position.x)
	camera.limit_top = int(limits.position.y)
	camera.limit_right = int(limits.position.x + limits.size.x)
	camera.limit_bottom = int(limits.position.y + limits.size.y)
	
	# Connecter les signaux du héro
	hero_instance.environment_damage.connect(_on_hero_environment_damage)
	hero_instance.hero_died.connect(_on_hero_died)
	
	# Affichage de la vie
	health_ui.visible = true
	health_ui.set_health(hero_instance.hp)
	
	# Netoyage de l'intro
	if intro_instance != null:
		intro_instance.queue_free()
		hero_instance.stop_hero("sleep")
		await get_tree().create_timer(6.0).timeout
		hero_instance.stop_hero("wake_up")
		await get_tree().create_timer(1.0).timeout
		hero_instance.allow_hero()

func _on_request_fade_in_out(duration_fade: float, duration_active: float) -> void:
	overlay.fade_in_out(duration_fade, duration_active)

func _on_request_dialogue_ui(dialogues: Array) -> void:
	dialogue_ui.start_dialogue(dialogues)

func _on_hero_environment_damage() -> void:
	if hero_instance == null:
		return
	
	health_ui.change_health(hero_instance.hp)
	
	hero_instance.stop_hero("hurt")
	camera.shake(1.0)
	overlay.fade_in_out(0.6, 0.2)
	await get_tree().create_timer(0.6).timeout
	hero_instance.global_position = current_environnement.get_safe_position(hero_instance.global_position) + Vector2(0, -12)
	hero_instance.allow_hero()

func _on_hero_died() -> void:
	if hero_instance == null:
		return
	
	health_ui.change_health(hero_instance.hp)
	overlay.fade_in_out(2.0, 1.0)
	await get_tree().create_timer(3.0).timeout
	
	hero_instance.global_position = current_environnement.get_checkpoint(hero_instance.global_position) + Vector2(0, -12)
	hero_instance.revive()
	health_ui.set_health(hero_instance.hp)
	hero_instance.allow_hero()
