class_name Checkbox
extends Control

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label

# Définit si la checkbox est coché ou non
func set_state(value: bool) -> void:
	if value:
		sprite.play("done")
	else:
		sprite.play("default")

# Permet de donner un texte au label
func set_text(text: String) -> void:
	label.text = text
