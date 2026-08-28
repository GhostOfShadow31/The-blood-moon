class_name CameraController
extends Camera2D

const SMOOTHING: float = 0.05
const LOOK_AHEAD: int = 30
const ROOM_WEIGHT: float = 0.25

var player: Player
var level: Level
var bounds: Rect2
var current_room: Area2D

# Setup à faire pour bien calibrer la caméra
func setup(p_player: Node2D, p_level: Level) -> void:
	player = p_player
	level = p_level
	bounds = p_level.get_camera_bounds()
	
	var target: Vector2 = player.global_position
	target = clamp_to_bounds(target)
	global_position = target

# MAJ à chaque frame
func _process(_delta) -> void:
	if player == null:
		return
	
	var target: Vector2 = player.global_position + get_look_ahead()
	
	var room: Dictionary = level.get_room_at(player.global_position)
	
	if room != {}:
		target = target.lerp(room.focus, ROOM_WEIGHT)
	
	target = clamp_to_bounds(target)
	
	global_position = global_position.lerp(target, SMOOTHING)

func get_look_ahead() -> Vector2:
	return Vector2(LOOK_AHEAD * sign(player.velocity.x), 0)

func clamp_to_bounds(pos: Vector2) -> Vector2:
	var half: Vector2 = get_viewport_rect().size / 2.0
	
	var min_pos: Vector2 = bounds.position + half
	var max_pos: Vector2 = bounds.end - half
	
	return Vector2(
		clamp(pos.x, min_pos.x, max_pos.x),
		clamp(pos.y, min_pos.y, max_pos.y)
	)
