extends AnimatedSprite2D

@onready var map_ui: Map_UI = get_parent()

const SNAP_DISTANCE: float = 7.5
const SNAP_SPEED: float = 50.0
const BOUNDS: Rect2 = Rect2(Vector2(90.0, 29), Vector2(130.0, 117))
const PLACEABLE_MARKER: PackedScene = preload("res://game/ui/map/components/PlaceableMarker.tscn")

var target_marker: Marker2D = null
var is_placing_marker: bool = false
var current_placeablemarker: PlaceableMarker = null

var current_map: Control = null
var current_markers: Array[Marker2D] = []

func _ready() -> void:
	visible = false
	play("default")

func process(delta: float) -> void:
	if is_placing_marker:
		handle_placing_marker()
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		handle_cursor_interaction()
	
	handle_cursor_movement(delta)

# Initialise le curseur
func initialize(map: Control) -> void:
	current_map = map

# Gère le déplacement du cuseur
func handle_cursor_movement(delta: float) -> void:
	var movement: Vector2 = get_cursor_direction()
	
	if movement == Vector2.ZERO:
		# Plus d'input : On cherche éventuellement un marqueur
		target_marker = get_closer_marker(global_position)
		
		if target_marker != null:
			global_position = global_position.move_toward(
				target_marker.position,
				SNAP_SPEED * delta
			)
		return
	
	# L'utilisateur controle le curseur normalement
	if not visible:
		visible = true
	
	target_marker = null
	global_position += movement
	global_position = clamp_to_bounds(global_position)

# Récupère la direction du curseur à l'input
func get_cursor_direction() -> Vector2:
	if Input.is_action_pressed("ui_left"):
		return Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		return Vector2.RIGHT
	elif Input.is_action_pressed("ui_up"):
		return Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		return Vector2.DOWN
	return Vector2.ZERO

# Récupère le marqueur le plus proche
func get_closer_marker(from_position: Vector2) -> Marker2D:
	var closest_marker: Marker2D = null
	var closest_distance: float = SNAP_DISTANCE
	
	for marker: Marker2D in current_markers:
		var distance: float = from_position.distance_to(marker.position)
		
		if distance < closest_distance:
			closest_distance = distance
			closest_marker = marker
	
	return closest_marker

# Permet de ne pas faire sortir la map du champ de vision
func clamp_to_bounds(pos: Vector2) -> Vector2:
	var min_pos: Vector2 = BOUNDS.position
	var max_pos: Vector2 = BOUNDS.end
	
	return Vector2(
		clamp(pos.x, min_pos.x, max_pos.x),
		clamp(pos.y, min_pos.y, max_pos.y)
	)

# Gérer l'interaction du curseur
func handle_cursor_interaction() -> void:
	if target_marker != null:
		if target_marker is PlaceableMarker:
			delete_marker()
		return
	
	is_placing_marker = true
	
	current_placeablemarker = PLACEABLE_MARKER.instantiate()
	current_map.get_node("Markers").add_child(current_placeablemarker)
	current_placeablemarker.name = "PlaceableMarker_01" # Incrémente avec _02 automatiquement
	current_placeablemarker.global_position = global_position
	visible = false

# Supprime un marqueur plaçable
func delete_marker() -> void:
	GameData.remove_marker(target_marker, Game_data.MAPS.CAVE)
	target_marker.free()
	target_marker = null
	map_ui.refresh_markers_list()

# Gérer la placement et la sélection d'un marqueur
func handle_placing_marker() -> void:
	if current_placeablemarker == null:
		return
	
	if Input.is_action_just_pressed("ui_left"):
		current_placeablemarker.previous_marker()
	if Input.is_action_just_pressed("ui_right"):
		current_placeablemarker.next_marker()
	if Input.is_action_just_pressed("ui_accept"):
		current_placeablemarker.hide_selector(true)
		
		visible = true
		is_placing_marker = false
		
		map_ui.refresh_markers_list()
		
		GameData.add_marker(current_placeablemarker, Game_data.MAPS.CAVE)
