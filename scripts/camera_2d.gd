extends Camera2D

const ZONE_SIZE: Vector2 = Vector2(320, 192)

@export var follow_speed: float = 6.0
@export var zone_center_speed: float = 2.0

@export_range(0.0, 1.0) var bias_x: float = 0.4
@export_range(0.0, 1.0) var bias_y: float = 0.1

var follow: Node2D

var current_zone: Vector2i = Vector2i(-1, -1)
var current_zone_center: Vector2 = Vector2.ZERO
var target_zone_center: Vector2 = Vector2.ZERO

func set_context(f: Node) -> void:
	follow = f
	
	# Zone logique courante
	current_zone = get_zone_index(follow.global_position)
	
	# Initialisation immédiate des centres
	current_zone_center = get_zone_center(current_zone)
	target_zone_center = current_zone_center
	
	# Placement immédiat de la caméra
	self.global_position = follow.global_position

func _process(delta: float) -> void:
	if follow == null:
		return
	
	var zone: Vector2i = get_zone_index(follow.global_position)
	
	if zone != current_zone:
		current_zone = zone
		target_zone_center = get_zone_center(zone)
	
	# Amortissement du centre de la zone
	current_zone_center = current_zone_center.lerp(
		target_zone_center,
		zone_center_speed * delta
	)
	
	#Cible caméra hybride
	var target: Vector2 = Vector2.ZERO
	target.x = lerp(current_zone_center.x, follow.global_position.x, bias_x)
	target.y = lerp(current_zone_center.y, follow.global_position.y, bias_y)
	
	# Suivi de caméra smooth
	self.global_position = lerp(
		self.global_position,
		target,
		follow_speed * delta
	)

func get_zone_index(pos: Vector2) -> Vector2i:
	return Vector2i(
		int(pos.x / ZONE_SIZE.x),
		int(pos.y / ZONE_SIZE.y)
	)

func get_zone_center(zone: Vector2i) -> Vector2:
	return Vector2(
		(zone.x + 0.5) * ZONE_SIZE.x,
		(zone.y + 0.5) * ZONE_SIZE.y,
	)
