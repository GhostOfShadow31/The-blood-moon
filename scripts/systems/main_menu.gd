extends Control

@onready var tilemap_effect = $Effect
@onready var black_screen = $BlackScreen
@onready var UI_container = $UIContainer
@onready var camera_menu = $Camera2D
@onready var pnj = $PNJJoueur
@onready var camera_pnj = $PNJJoueur/Camera2D

signal start_cinematic(is_on: bool)

var fade_speed = 0.1
var is_play_button_clicked = false

func _ready() -> void:
	black_screen.visible = true
	UI_container.visible = true
	
	camera_menu.make_current()

func _process(delta: float) -> void:
	if black_screen.modulate.a > 0.0:
		black_screen.modulate.a -= fade_speed * delta
		if black_screen.modulate.a < 0.0:
			black_screen.modulate.a = 0.0
	
	if is_play_button_clicked and UI_container.modulate.a > 0.0:
		UI_container.modulate.a -= fade_speed * delta * 10
		if UI_container.modulate.a < 0.0:
			UI_container.modulate.a = 0.0

func _on_play_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/chapitres/grotte.tscn")
	emit_signal("start_cinematic", true)
	is_play_button_clicked = true
	start_camera_transition_move()
	start_camera_transition_zoom()

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

func start_camera_transition_zoom():
	var tween = create_tween()
	tween.tween_property(camera_menu, "zoom", Vector2(2.25, 2.25), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func start_camera_transition_move():
	var tween = create_tween()
	tween.tween_property(camera_menu, "position", pnj.global_position, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "_switch_to_gameplay_camera"))

func _switch_to_gameplay_camera():
	camera_pnj.make_current()
