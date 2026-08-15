extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.visible = false

func show_death(value: bool) -> void:
	sprite.visible = value

func go_to(new_position: Vector2) -> void:
	global_position = new_position
