extends Control

const OFFSET: Vector2 = Vector2(0.0, 180.0)

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var color_rect: ColorRect = $ColorRect
@onready var maps: Control = $Maps
@onready var player_marker: Marker2D = $PlayerMarker

var current_level: Level = null
var player: Player = null

# Initialise la map
func initialize(p: Player, l: Level) -> void:
	player = p
	current_level = l

# Marque une salle comme découverte
# Cette dernière st donc visible sur la carte
func discover_room(room_id: int) -> void:
	GameData.add_room(room_id)

# Rend la carte active (refresh etc)
func set_active(value: bool) -> void:
	if value:
		canvas_modulate.visible = true
		
		var tween := create_tween()
		tween.tween_property(self, "global_position", global_position - OFFSET, 0.15)
		tween.parallel().tween_property(color_rect, "modulate:a", 0.75, 0.15)
		
		refresh()
	else:
		var tween := create_tween()
		tween.tween_property(self, "global_position", global_position + OFFSET, 0.15)
		tween.parallel().tween_property(color_rect, "modulate:a", 0.0, 0.15)
		await tween.finished
		
		canvas_modulate.visible = false

# Rafraîchit la carte
func refresh() -> void:
	var container: Node = maps.find_child(current_level.MAP_ID)
	for i in range(current_level.ROOMS_NUMBER):
		container.get_child(i).visible = GameData.has_room(i + 1)
	
	var normalized: Vector2 = (player.global_position - current_level.get_camera_bounds().position) / current_level.get_camera_bounds().size
	player_marker.position = normalized * Vector2(125, 107) + Vector2(92, 33)
	print(player_marker.position)
