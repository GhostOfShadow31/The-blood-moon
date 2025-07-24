extends Area2D

func _ready():
	await get_tree().process_frame
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":  # Ou un autre critère pour reconnaître le joueur
			var camera = get_viewport().get_camera_2d()
			camera.follow_player(true)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var camera = get_viewport().get_camera_2d()
		camera.follow_player(true)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		var camera = get_viewport().get_camera_2d()
		camera.follow_player(false)
