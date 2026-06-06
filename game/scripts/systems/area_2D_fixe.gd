extends Area2D

@export var camera_target_position: Vector2

func _ready():
	await get_tree().process_frame
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":  # Ou un autre critère pour reconnaître le joueur
			var camera = get_viewport().get_camera_2d()
			camera.set_position_at_start(camera_target_position)
	
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var camera = get_viewport().get_camera_2d()
		camera.set_target_position(camera_target_position)
