extends Control

@onready var tilemap_effect = $Effect
@onready var black_screen = $BlackScreen
@onready var black_screen2 = $BlackScreen2
@onready var UI_container = $UIContainer
@onready var pnj = $PNJJoueur
@onready var livre = $Livre
@onready var camera_menu = $Camera2D
@onready var camera_pnj = $PNJJoueur/Camera2D

signal start_cinematic(is_on: bool)

var fade_speed = 0.1
var is_play_button_clicked = false
var is_zoom_on_book = false
var main_menu_steps = ""
var black_screen_1_enabled = true

func _ready() -> void:
	pnj.zoom_book.connect(_on_zoom_book)
	StoryManager.step_finished.connect(_on_monologue_finished)
	
	black_screen.visible = true
	black_screen2.visible = false
	UI_container.visible = true
	
	black_screen2.modulate.a = 0.0
	
	livre.size = Vector2(16, 16)
	livre.stretch_mode = TextureRect.STRETCH_SCALE
	
	camera_menu.make_current()
	
	# Accès aux dialogues
	var file = FileAccess.open("res://story/storyMainMenu.json", FileAccess.READ)
	var content = file.get_as_text()
	main_menu_steps = JSON.parse_string(content)

func _play_scene(index: int):
	# On lance la story avec ces étapes
	StoryManager.play_story(main_menu_steps, index)

func _process(delta: float) -> void:
	if black_screen_1_enabled:
		if black_screen.modulate.a > 0.0:
			black_screen.modulate.a -= fade_speed * delta
			if black_screen.modulate.a < 0.0:
				black_screen.modulate.a = 0.0
	else:
		if black_screen.modulate.a < 1.0:
			black_screen.modulate.a += fade_speed * delta * 4
			if black_screen.modulate.a > 1.0:
				black_screen.modulate.a = 1.0
				get_tree().change_scene_to_file("res://scenes/chapitres/grotte.tscn")
	
	if is_play_button_clicked and UI_container.modulate.a > 0.0:
		UI_container.modulate.a -= fade_speed * delta * 10
		if UI_container.modulate.a < 0.0:
			UI_container.modulate.a = 0.0
	
	if is_zoom_on_book:
		if black_screen2.modulate.a < 1.0:
			black_screen2.modulate.a += fade_speed * delta * 4
			if black_screen2.modulate.a > 1.0:
				black_screen2.modulate.a = 1.0
				livre.texture = preload("res://assets/item/livre-ouvert.png")
				_play_scene(0)
	
	if Input.is_action_just_pressed("ui_accept") and StoryManager.is_playing:
		DialogueUi.advance_or_close()

func _on_play_button_pressed() -> void:
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

func _on_zoom_book():
	var tween = create_tween()
	
	var livre_center = livre.global_position + livre.size * 0.5 * livre.scale
	
	var target_pos = camera_pnj.get_parent().to_local(livre_center)
	
	black_screen2.visible = true
	is_zoom_on_book = true
	
	tween.tween_property(camera_pnj, "position", target_pos, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera_pnj, "zoom", Vector2(100, 100), 4.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_monologue_finished(who: String):
	if who != "Narrateur":
		return
	black_screen_1_enabled = false
