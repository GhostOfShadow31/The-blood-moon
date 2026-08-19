extends Control

var is_inventory_visible: bool = false

func toggle_inventory() -> void:
	is_inventory_visible = not is_inventory_visible
	if is_inventory_visible:
		show_inventory()
	else:
		hide_inventory()

func show_inventory() -> void:
	print("show_inventory()")

func hide_inventory() -> void:
	print("hide_inventory()")

func show_dialog() -> void:
	print("show_dialog()")

func hide_dialog() -> void:
	print("hide_dialog()")
