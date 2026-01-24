extends Node2D

@onready var safe_positions: Node2D = $Safe_positions
@onready var checkpoints: Node2D = $Checkpoints

@export var camera_bound: Rect2 = Rect2(
	Vector2.ZERO,
	Vector2(976, 576)
)

func get_camera_bound() -> Rect2:
	return camera_bound

func get_safe_position(from_position: Vector2) -> Vector2:
	var positions = safe_positions.get_children()
	
	var choosen = null # Marker2D
	var best_score: float = INF
	
	for p in positions:
		var score: float = _evaluate_safe_position(from_position, p.global_position)
		if score < best_score:
			best_score = score
			choosen = p
	
	return choosen.global_position if choosen else from_position

func _evaluate_safe_position(from: Vector2, to: Vector2) -> float:
	# Règle par défaut
	return from.distance_squared_to(to)

func get_checkpoint(from_position: Vector2) -> Vector2:
	var positions = checkpoints.get_children()
	
	var choosen = positions[0] # Default
	var best_score: float = INF
	for p in positions:
		if p is not Marker2D:
			var score: float = _evaluate_safe_position(from_position, p.position)
			if score < best_score and p.is_activated():
				best_score = score
				choosen = p
	
	return choosen.global_position if choosen else from_position
