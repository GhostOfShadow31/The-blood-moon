class_name Map_UI
extends Control

const OFFSET: Vector2 = Vector2(0.0, 180.0)

@onready var color_rect: ColorRect = $ColorRect
@onready var cursor: AnimatedSprite2D = $Cursor
@onready var maps: Control = $Maps

var maps_by_level: Dictionary[String, Control] = {}

var player: Player = null
var is_map_active: bool = false

var current_level: Level = null
var current_map: Control = null
var current_markers: Array[Marker2D] = []

# Initialise la map
func initialize(p: Player, l: Level) -> void:
	player = p
	current_level = l
	
	current_map = maps_by_level[current_level.MAP_ID]
	cursor.initialize(current_map)
	
	refresh_markers_list()


func _ready() -> void:
	for map in maps.get_children():
		maps_by_level[map.name] = map

func _process(delta: float) -> void:
	if not is_map_active:
		return
	
	cursor.process(delta)

# Rafraichit la liste des marqueurs
func refresh_markers_list() -> void:
	var current_markers_nodes = current_map.get_node("Markers").get_children()
	current_markers.clear()
	for child in current_markers_nodes:
		current_markers.append(child as Marker2D)
	
	# Notifier le curseur
	cursor.current_markers = current_markers

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

# Rafraîchit la carte
func refresh() -> void:
	var map_container: Control = current_map.get_node("Rooms")
	for i in range(current_level.get_rooms_number()):
		map_container.get_child(i).visible = GameData.has_room(i + 1)
	
	var normalized: Vector2 = (player.global_position - current_level.get_camera_bounds().position) / current_level.get_camera_bounds().size
	var player_marker: Marker2D = current_map.get_node("Markers/PlayerMarker")
	player_marker.position = normalized * Vector2(125, 107) + Vector2(92, 33)
