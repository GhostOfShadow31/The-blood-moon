extends CanvasLayer

@export var path_node: NodePath

@onready var v_box_container = get_node(path_node).get_child(0).get_child(0)
@onready var center_container = $CenterContainer

var last_row := 0
var last_col := 0
var is_inventory_active := false

func _ready() -> void:
	self.visible = true
	center_container.global_position = Vector2(center_container.global_position.x, center_container.global_position.y + 500)

func _show():
	is_inventory_active = true
	var tween = create_tween()
	tween.tween_property(center_container, "position", Vector2(center_container.global_position.x, center_container.global_position.y - 500), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func _hide() -> void:
	is_inventory_active = false
	var tween = create_tween()
	tween.tween_property(center_container, "position", Vector2(center_container.global_position.x, center_container.global_position.y + 500), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# Ajouter un item
func _add_item(item_path: String):
	var texture := load(item_path)
	var added := false
	
	var row := last_row
	var col := last_col
	
	while row < v_box_container.get_child_count():
		var h_box_container: HBoxContainer = v_box_container.get_child(row)
		while col < h_box_container.get_child_count():
			var slot := h_box_container.get_child(col)
			var texture_rect: TextureRect = slot.get_child(0)
			if texture_rect.texture == null:
				texture_rect.texture = texture
				#texture_rect.size = Vector2(48, 48)
				last_row = row
				last_col = col + 1
				if last_col >= h_box_container.get_child_count():
					last_col = 0
					last_row = 0
				added = true
				return
			col += 1
		row += 1
		col = 0
	if not added:
		push_warning("Inventaire plein")

# Retirer un item
func _remove_item(row: int, col: int):
	var h_box_container: HBoxContainer = v_box_container.get_child(row)
	var slot := h_box_container.get_child(col)
	var texture_rect: TextureRect = slot.get_child(0)
	texture_rect.texture = null
