extends Control

const OFFSET: Vector2 = Vector2(0.0, 100.0)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var content: Control = $AnimatedSprite2D/Content

var is_validator_active: bool = false

# Montre le validateur
func show_validator() -> void:
	sprite.play("open")
	var tween = create_tween()
	tween.tween_property(sprite, "position", sprite.position - OFFSET, 0.15)
	await sprite.animation_finished
	sprite.play("openned")
	
	content.visible = true
	is_validator_active = true

# Masque le validateur
func hide_validator() -> void:
	content.visible = false
	
	sprite.play("close")
	var tween = create_tween()
	tween.tween_property(sprite, "position", sprite.position + OFFSET, 0.15)
	await sprite.animation_finished
	sprite.play("closed")
	
	is_validator_active = true
