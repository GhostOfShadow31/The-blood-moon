extends Control

const FEEDBACK_ITEM: PackedScene = preload("res://game/ui/feedback/FeddbackItem.tscn")

@onready var container: VBoxContainer = $VBoxContainer

func _ready() -> void:
	for child in container.get_children():
		child.queue_free()

func show_loot(loot: Dictionary) -> void:	
	for item in loot:
		_add_feedback(item, loot[item])
		await get_tree().create_timer(0.75).timeout

func _add_feedback(item: Item, quantity: int) -> void:
	var feedback_item: FeedbackItem = FEEDBACK_ITEM.instantiate()
	container.add_child(feedback_item)
	container.move_child(feedback_item, 0)
	feedback_item.set_object(item.icon, quantity)
	feedback_item.play_animation()
