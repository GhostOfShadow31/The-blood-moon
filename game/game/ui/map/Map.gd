extends Control

const OFFSET: Vector2 = Vector2(0.0, 180.0)
const SNAP_DISTANCE: float = 7.5
const SNAP_SPEED: float = 50.0

const BOUNDS: Rect2 = Rect2(Vector2(90.0, 29), Vector2(130.0, 117))

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var color_rect: ColorRect = $ColorRect
@onready var cursor: AnimatedSprite2D = $Cursor
@onready var maps: Control = $Maps

var maps_by_level: Dictionary[String, Control] = {}

var player: Player = null
var is_map_active: bool = false
var target_marker: Node = null

var current_level: Level = null
var current_map: Control = null
var current_markers: Array[Marker2D] = []

# Initialise la map
func initialize(p: Player, l: Level) -> void:
	player = p
	current_level = l
	
	current_map = maps_by_level[current_level.MAP_ID]
	
	var current_markers_nodes = current_map.get_node("Markers").get_children()
	for child in current_markers_nodes:
		current_markers.append(child as Marker2D)
	
	cursor.visible = false

func _ready() -> void:
	for map in maps.get_children():
		maps_by_level[map.name] = map

func _process(delta: float) -> void:
	if not is_map_active:
		return
	
	var movement: Vector2 = get_cursor_direction()
	
	if movement == Vector2.ZERO:
		# Plus d'input : On cherche éventuellement un marqueur
		var marker: Marker2D = get_closer_marker(cursor.global_position)
		
		if marker != null:
			cursor.global_position = cursor.global_position.move_toward(
				marker.position,
				SNAP_SPEED * delta
			)
		
		return
	
	# L'utilisateur controle le curseur normalement
	if not cursor.visible:
		cursor.visible = true
	
	cursor.global_position += movement
	cursor.global_position = clamp_to_bounds(cursor.global_position)

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

# Marque une salle comme découverte
# Cette dernière st donc visible sur la carte
func discover_room(room_id: int) -> void:
	GameData.add_room(room_id)

# Rend la carte active (refresh etc)
func set_active(value: bool) -> void:
	if value:
		var tween := create_tween()
		tween.tween_property(maps, "global_position", maps.global_position - OFFSET, 0.15)
		tween.parallel().tween_property(color_rect, "modulate:a", 0.75, 0.15)
		
		refresh()
		
		await tween.finished
		
		cursor.global_position = get_viewport_rect().size / 2.0
		
	else:
		cursor.visible = false
		var tween := create_tween()
		tween.tween_property(maps, "global_position", maps.global_position + OFFSET, 0.15)
		tween.parallel().tween_property(color_rect, "modulate:a", 0.0, 0.15)
		await tween.finished
	
	is_map_active = value
	canvas_modulate.visible = value

# Rafraîchit la carte
func refresh() -> void:
	var map_container: Control = current_map.get_node("Rooms")
	for i in range(current_level.get_rooms_number()):
		map_container.get_child(i).visible = true#GameData.has_room(i + 1)
	
	var normalized: Vector2 = (player.global_position - current_level.get_camera_bounds().position) / current_level.get_camera_bounds().size
	var player_marker: Marker2D = current_map.get_node("Markers/PlayerMarker")
	player_marker.position = normalized * Vector2(125, 107) + Vector2(92, 33)

# Permet de ne pas faire sortir la map du champ de vision
func clamp_to_bounds(pos: Vector2) -> Vector2:
	var min_pos: Vector2 = BOUNDS.position
	var max_pos: Vector2 = BOUNDS.end
	
	return Vector2(
		clamp(pos.x, min_pos.x, max_pos.x),
		clamp(pos.y, min_pos.y, max_pos.y)
	)

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

# Si un marquer est proche du curseur, le curseur est attiré par ce dernier
func snap_to_marker(from_position: Vector2) -> Vector2:
	var closest_marker: Node = null
	var closest_distance: float = SNAP_DISTANCE
	
	for marker in current_markers:
		var distance: float = from_position.distance_to(marker.position)
		
		if distance < closest_distance:
			closest_distance = distance
			closest_marker = marker
	
	if closest_marker != null:
		target_marker = closest_marker
		return closest_marker.position
	
	return from_position
