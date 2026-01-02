extends Node2D

@export var camera_bound: Rect2 = Rect2(
	Vector2.ZERO,
	Vector2(976, 576)
)

func get_camera_bound() -> Rect2:
	return camera_bound
