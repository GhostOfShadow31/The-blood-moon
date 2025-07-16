extends Area2D

@export var camera_target_position: Vector2

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var camera = get_viewport().get_camera_2d()
		camera.set_target_position(camera_target_position)
