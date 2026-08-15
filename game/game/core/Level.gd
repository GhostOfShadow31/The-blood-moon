class_name Level
extends Node

var rooms: Array[Dictionary]

# Définit la limite d'une caméra dans un niveau
func get_camera_bounds() -> Rect2:
	assert(false, "Must be implemented")
	return Rect2()

# Position d'entrée dans le niveau
func get_spawn_position(_spawn_context: SpawnContext) -> Vector2:
	assert(false, "Must be implemented")
	return Vector2.ZERO

# Position où replacer le joueur après avoir pris des dégâts d'environnement (piques, chute, etc.)
func get_safe_recovery_position(_death_position: Vector2) -> Vector2:
	assert(false, "Must be implemented")
	return Vector2.ZERO

# Récupérer la position centrale de la salle ou rien (null)
func get_room_at(position: Vector2):
	for room: Dictionary in rooms:
		if room.bounds.has_point(position):
			return room.focus
	return null
