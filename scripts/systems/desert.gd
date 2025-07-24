extends Node2D

signal player_position(Vector2)

func _ready() -> void:
	emit_signal("player_position", Vector2(3280, 20))
