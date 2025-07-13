extends Control

@onready var tilemap_effect = $Effect
@onready var black_screen = $BlackScreen

var fade_speed = 0.1

func _ready() -> void:
	black_screen.visible = true

func _process(delta: float) -> void:
	if black_screen.modulate.a > 0.0:
		black_screen.modulate.a -= fade_speed * delta
		if black_screen.modulate.a < 0.0:
			black_screen.modulate.a = 0.0

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/chapitres/grotte.tscn")
	# Remplcer par une scène d'intro ici

func _on_settings_button_pressed() -> void:
	print("Paramètre non-implémenter")

func _on_quit_play_pressed() -> void:
	get_tree().quit()

func _on_porte_chateau_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		tilemap_effect.visible = true

func _on_porte_chateau_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		tilemap_effect.visible = false
