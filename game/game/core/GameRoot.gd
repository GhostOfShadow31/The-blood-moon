extends Node

const LEVELS = {
	"intro": preload("res://game/levels/intro/intro_scene.tscn"),
	"cave": preload("res://game/levels/cave/CaveLevel.tscn")
}

var current_level: Level

@onready var world: Node2D = $World
@onready var player: Node2D = $Player
@onready var death: Node2D = $Death
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	start_game()
	setup_camera()

func _physics_process(_delta: float) -> void:
	if current_level.is_spike(player.get_hurtbox().global_position):
		handle_spike_damage()

# Obtenir une scène à partir de son identifiant
func get_level_scene(level_id: String) -> PackedScene:
	return LEVELS[level_id]

# Démarrer le jeu
func start_game() -> void:
	var spawn_context: SpawnContext = SpawnContext.new()
	spawn_context.type = SpawnContext.Type.FIRST_SPAWN
	
	change_level("cave", spawn_context) # Modifier ici pour jouer la scène voulu au démarrage

# Changer de niveau
func change_level(level_id: String, spawn_context: SpawnContext) -> void:
	load_level(level_id)
	
	place_player(spawn_context)

# Charger un niveau
func load_level(level_id: String) -> void:
	if current_level != null:
		current_level.queue_free()
	
	var scene: PackedScene = get_level_scene(level_id)
	
	current_level = scene.instantiate()
	
	world.add_child(current_level)

# Placer un joueur
func place_player(spawn_context: SpawnContext) -> void:
	var spawn_position: Vector2 = current_level.get_spawn_position(spawn_context)
	
	player.global_position = spawn_position

# Setup de la caméra
func setup_camera() -> void:
	camera.setup(player, current_level)

# Gère les dégâts d'environnement
func handle_spike_damage() -> void:
	var damage_taken: int = 1
	player.take_damage(damage_taken)
	if player.get_health() == 1:
		current_level.switch_to_death_ambiance(true)
	hit_freeze(0.025)
	player.apply_knockback(player.global_position)
	await get_tree().create_timer(0.25).timeout
	if player.is_dead():
		death.show_death(true)
		death.go_to(current_level.get_death_position(player.global_position))
		# Démarrer dialogue ici
		player.recover(current_level.get_safe_recovery_position(player.global_position))
		await get_tree().create_timer(5.0).timeout
		death.show_death(false)
		current_level.switch_to_death_ambiance(false)
		player.set_hp(player.max_health)
	else:
		player.recover(current_level.get_safe_recovery_position(player.global_position))

# Freeze l'écran durant une durée
func hit_freeze(duration: float) -> void:
	Engine.time_scale = 0.05
	await get_tree().create_timer(duration, true).timeout
	Engine.time_scale = 1.0
