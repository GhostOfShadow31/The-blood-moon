extends Control

const OFFSET: Vector2 = Vector2(0.0, 180.0)
const BOUNDS: Rect2 = Rect2(Vector2(90.0, 29), Vector2(130.0, 117))

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var color_rect: ColorRect = $ColorRect
@onready var maps: Control = $Maps
@onready var player_marker: Marker2D = $PlayerMarker
@onready var cursor: AnimatedSprite2D = $Cursor

var current_level: Level = null
var player: Player = null
var is_map_active: bool = false

# Initialise la map
func initialize(p: Player, l: Level) -> void:
	player = p
	current_level = l

# Délpacer la carte
func _process(_delta: float) -> void:
	if not is_map_active:
		return
	
	var direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction = Vector2(-10.5, 0.0)
	elif Input.is_action_pressed("ui_right"):
		direction = Vector2(10.5, 0.0)
	elif Input.is_action_pressed("ui_up"):
		direction = Vector2(0.0, -10.5)
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2(0.0, 10.5)
	
	if direction != Vector2.ZERO:
		cursor.global_position += direction
		cursor.global_position = clamp_to_bounds(cursor.global_position)
	

# Marque une salle comme découverte
# Cette dernière st donc visible sur la carte
func discover_room(room_id: int) -> void:
	GameData.add_room(room_id)

# Rend la carte active (refresh etc)
func set_active(value: bool) -> void:
	is_map_active = value
	canvas_modulate.visible = value
	if value:
		var tween := create_tween()
		tween.tween_property(maps, "global_position", maps.global_position - OFFSET, 0.15)
		tween.parallel().tween_property(color_rect, "modulate:a", 0.75, 0.15)
		
		refresh()
	else:
		var tween := create_tween()
		tween.tween_property(maps, "global_position", maps.global_position + OFFSET, 0.15)
		tween.parallel().tween_property(color_rect, "modulate:a", 0.0, 0.15)
		await tween.finished
		
		cursor.global_position = Vector2.ZERO + OFFSET

# Rafraîchit la carte
func refresh() -> void:
	var container: Node = maps.find_child(current_level.MAP_ID)
	for i in range(current_level.ROOMS_NUMBER):
		container.get_child(i).visible = true#	GameData.has_room(i + 1)
	
	var normalized: Vector2 = (player.global_position - current_level.get_camera_bounds().position) / current_level.get_camera_bounds().size
	player_marker.position = normalized * Vector2(125, 107) + Vector2(92, 33)

# Permet de ne pas faire sortir la map du champ de vision
func clamp_to_bounds(pos: Vector2) -> Vector2:
	var min_pos: Vector2 = BOUNDS.position
	var max_pos: Vector2 = BOUNDS.end
	
	return Vector2(
		clamp(pos.x, min_pos.x, max_pos.x),
		clamp(pos.y, min_pos.y, max_pos.y)
	)
