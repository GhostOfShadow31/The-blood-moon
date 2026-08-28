class_name FeedbackItem
extends Control

const OFFSET: Vector2 = Vector2(-50.0, 0.0)

@onready var control: Control = $Control
@onready var sprite: Sprite2D = $Control/Sprite2D
@onready var label: Label = $Control/Label

func set_object(texture: Texture, quantity: int) -> void:
	sprite.texture = texture
	label.text = "x " + str(quantity)

func clear() -> void:
	sprite.texture = null
	label.text = ""

func play_animation() -> void:
	control.modulate.a = 0.0
	
	var tween = create_tween()
	
	tween.tween_property(control, "modulate:a", 1.0, 0.25)
	tween.tween_interval(2.0)
	tween.tween_property(control, "position", control.position + OFFSET, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	tween.tween_callback(queue_free)
	
