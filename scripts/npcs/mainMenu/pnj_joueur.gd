extends Node2D

@export var speed = 100
@export var path_node: NodePath

@onready var animated_sprite = $AnimatedSprite2D
@onready var path_points = get_node(path_node)
@onready var origin: Vector2 = path_points.get_node("Origin").global_position
@onready var main_menu = self.get_parent()

signal zoom_book

var points: Array = []
var _current_index = 0
var is_cinematic = false
var is_signal_send = false
var wait_timer = 0.0

func _ready():
	# Connection des signaux
	main_menu.start_cinematic.connect(_on_cinematic_on)
	
	# Trouve le point de départ
	global_position = origin
	
	# On ajoute toutes les positions dans un tableau
	for child in path_points.get_children():
		if child.name == "Origin":
			continue
		
		var point_data = {
			"position": child.global_position,
			"wait": 0.0
		}
		
		if child.name.begins_with("Wait_"):
			var parts = child.name.split("_")
			if parts.size() >= 2:
				point_data["wait"] = float(parts[1])
		
		points.append(point_data)

func _process(delta: float) -> void:
	if points.is_empty():
		return
	
	if wait_timer > 0:
		wait_timer -= delta
		return
	
	if not is_signal_send and _current_index >= points.size():
		is_signal_send = true
		emit_signal("zoom_book")
	
	if _current_index >= points.size():
		animated_sprite.play("wait")
		return
	
	if is_cinematic:
		var target = points[_current_index]["position"]
		var direction = (target - global_position).normalized()
		_update_animation(direction)
		global_position += direction * speed * delta
		
		if global_position.distance_squared_to(target) < 5:
			wait_timer = points[_current_index]["wait"]
			_current_index += 1

func _update_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animated_sprite.play("walk_right")
		else:
			animated_sprite.play("walk_left")
	else:
		if direction.y > 0:
			animated_sprite.play("walk_down")
		else:
			animated_sprite.play("walk_up")

func _on_cinematic_on(is_on: bool):
	is_cinematic = is_on
