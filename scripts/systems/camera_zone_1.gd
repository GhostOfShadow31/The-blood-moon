extends Area2D

@export var camera_target_position: Vector2

func _ready():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":  # Ou un autre critère pour reconnaître le joueur
			_on_body_entered(body)  # Appelle la fonction manuellement

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var camera = get_viewport().get_camera_2d()
		camera.set_target_position(camera_target_position)
