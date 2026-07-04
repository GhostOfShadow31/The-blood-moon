extends Level

@onready var map: Node2D = $CaveMap

func _ready() -> void:
	for room in map.rooms:
		if room is Dictionary:
			rooms.append(room)

# -- Implémentation de l'interface --
func get_camera_bounds() -> Rect2:
	return map.CAMERA_BOUNDS

func get_spawn_position(spawn_context: SpawnContext) -> Vector2:
	var spawnpoint_markers: Array[Node] = map.spawnpoint_markers.get_children()
	
	if spawn_context.type == SpawnContext.Type.FIRST_SPAWN:
		for marker in spawnpoint_markers:
			if marker.name == "Default":
				return marker.global_position
		push_error("ERROR: No first spawn found")
		return Vector2.ZERO
	
	assert(false, "Must be implemented")
	return Vector2.ZERO

func get_respawn_position(death_position: Vector2) -> Vector2:
	var checkpoint_markers: Array[Node2D] = map.checkpoint_markers.get_children()
	
	if checkpoint_markers.is_empty():
		push_warning("WARN: No checkpoint position available, go to default spwanpoint")
		var ctx = SpawnContext.new()
		ctx.type = SpawnContext.Type.FIRST_SPAWN
		return get_spawn_position(ctx)
	
	return get_closer_position(death_position, checkpoint_markers)

func get_safe_recovery_position(death_position: Vector2) -> Vector2:
	var recovery_markers: Array[Node2D] = map.recovery_markers.get_children()
	
	if recovery_markers.is_empty():
		push_warning("WARN: No recovery position available, try to go to checkpoint")
		return get_respawn_position(death_position)
	
	return get_closer_position(death_position, recovery_markers)

# Renvoie la position la plus proche
func get_closer_position(from: Vector2, positions: Array[Node2D]) -> Vector2:
	var choosen_position: Node2D = null
	var best_score: float = INF
	
	for position: Node2D in positions:
		var vector: Vector2 = position.global_position
		var score = from.distance_to(vector)
		if score < best_score:
			choosen_position = position
			best_score = score
	
	return choosen_position.global_position
