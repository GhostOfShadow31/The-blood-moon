extends Level

const MAP_ID: String = "cave"
const ROOMS_NUMBER: int = 15

@onready var map: Node2D = $CaveMap

func _ready() -> void:
	for room in map.rooms:
		if room is Dictionary:
			rooms.append(room)

func is_spike(from_position: Vector2) -> bool:
	return map.is_spike(from_position)

# -- Implémentation de l'interface --
func get_camera_bounds() -> Rect2:
	return map.CAMERA_BOUNDS

func get_spawn_position(spawn_context: SpawnContext) -> Vector2:
	var spawnpoints: Array[Node] = map.spawnpoints.get_children()
	
	if spawn_context.type == SpawnContext.Type.FIRST_SPAWN:
		for marker in spawnpoints:
			if marker.name == "Default":
				return marker.global_position
		push_error("ERROR: No first spawn found")
		return Vector2.ZERO
	
	assert(false, "Must be implemented")
	return Vector2.ZERO

func get_safe_recovery_position(death_position: Vector2) -> Vector2:
	var recoverypoints: Array[Node] = map.recoverypoints.get_children()
	
	if recoverypoints.is_empty():
		push_warning("WARN: No recovery position available, go to default spwanpoint")
		var ctx = SpawnContext.new()
		ctx.type = SpawnContext.Type.FIRST_SPAWN
		return get_spawn_position(ctx)
	
	return get_closer_position(death_position, recoverypoints)

func get_death_position(death_position: Vector2) -> Vector2:
	var death_poistions: Array[Node] = map.death_positions.get_children()
	return get_closer_position(death_position, death_poistions)

func switch_to_death_ambiance(value: bool) -> void:
	var tween := create_tween()
	if value:
		tween.tween_property(map.canva_modulate, "color", map.CANVAS_MODULATE_SHADE["death"], 0.75)
	else:
		tween.tween_property(map.canva_modulate, "color", map.CANVAS_MODULATE_SHADE["default"], 0.75)

func get_enemies() -> Array[Enemy]:
	var pnjs: Array[Node] = map.pnjs.get_children()
	var enemies: Array[Enemy] = []
	for pnj: Node in pnjs:
		if pnj is Enemy:
			enemies.append(pnj)
	
	return enemies

# Renvoie la position la plus proche
func get_closer_position(from: Vector2, positions: Array[Node]) -> Vector2:
	var choosen_position: Node2D = null
	var best_score: float = INF
	
	for position: Node in positions:
		var vector: Vector2 = position.global_position
		var score = from.distance_to(vector)
		if score < best_score:
			choosen_position = position
			best_score = score
	
	return choosen_position.global_position
