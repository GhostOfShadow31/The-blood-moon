extends Node2D

@export var speed = 100
@export var path_node: NodePath # Pour récupérer les déplacements

@onready var animated_sprite = $AnimatedSprite2D
@onready var path_points = get_node(path_node)
@onready var origin: Vector2 = path_points.get_node("Origin").global_position # Point de départ du pnj

var points: Array = []
var _current_index = 0
var wait_timer = 0.0
var wait_direction = ""

# Permet d'évauler la distance totale parcouru
# Ainsi que le temps parcouru : somme / speed
var somme = 0.0

func _ready():
	# Trouve le point de départ
	global_position = origin
	
	# Pour calculer la somme
	var last_position = origin
	
	# On ajoute toutes les positions dans un tableau
	for child in path_points.get_children():
		if child.name == "Origin":
			continue
		
		var point_data = {
			"position": child.global_position,
			"wait": 0.0,
			"wait_direction": ""
		}
		
		# Ce genre de Noeud signifie au pnj qu'il doit attendre à sa position
		# Ex: Wait_2-35_left signifie attendre 2,35s dans la direction gauche
		if child.name.begins_with("Wait_"):
			var parts = child.name.split("_")
			if parts.size() >= 3:
				var timer = parts[1].split("-")
				if timer.size() >= 2:
					point_data["wait"] = float(timer[0]) + float(timer[1])/100
				else:
					point_data["wait"] = float(timer[0])
				point_data["wait_direction"] = parts[2]
		
		points.append(point_data)
		
		# Ajoute la distance entre last_position et ce point
		somme += last_position.distance_to(child.global_position)
		last_position = child.global_position

	# On rajoute la distance du dernier point vers l'origine :
	somme += last_position.distance_to(origin)

	# print("Distance totale du trajet: ", somme)

func _process(delta: float) -> void:
	if points.is_empty(): # Pas de déplacements
		return
	
	if wait_timer > 0: # Permet d'attendre
		wait_timer -= delta
		_update_wait_animation()
		return
	
	var target = points[_current_index]["position"]
	var direction = (target - global_position).normalized()
	_update_animation(direction)
	global_position += direction * speed * delta
	
	# On se déplace jusqu'à la prochaine position
	if global_position.distance_squared_to(target) < 5:
		wait_timer = points[_current_index]["wait"]
		wait_direction = points[_current_index]["wait_direction"]
		_current_index = (_current_index + 1) % points.size()

# Permet de mettre à jour les animations
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

# Permet de mettre à jour les animations d'attentes
func _update_wait_animation():
	if wait_direction != "":
		animated_sprite.play("wait_" + wait_direction)
