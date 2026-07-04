extends Node

const LEVELS = {
	"intro": preload("res://game/levels/intro/intro_scene.tscn"),
	"cave": preload("res://game/levels/cave/CaveLevel.tscn")
}

var current_level: Level

@onready var world: Node2D = $World
@onready var player: Node2D = $Player
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	start_game()
	setup_camera()

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
