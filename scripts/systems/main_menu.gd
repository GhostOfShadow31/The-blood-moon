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

# Joue une scène de la story
func _play_scene(index: int):
	# On lance la story avec ces étapes
	StoryManager.play_story(main_menu_steps, index)

func _process(delta: float) -> void:
	# Effect avec premier black screen
	if black_screen_1_enabled:
		if black_screen.modulate.a > 0.0:
			black_screen.modulate.a -= fade_speed * delta
			if black_screen.modulate.a < 0.0:
				black_screen.modulate.a = 0.0
	
	# A la fin, le black screen revient pour faire une transition
	else:
		if black_screen.modulate.a < 1.0:
			black_screen.modulate.a += fade_speed * delta * 4
			if black_screen.modulate.a > 1.0:
				black_screen.modulate.a = 1.0
				get_tree().change_scene_to_file("res://scenes/chapitres/grotte.tscn")
	
	# Effect pour faire disparaître le titre et les boutons
	if is_play_button_clicked and UI_container.modulate.a > 0.0:
		UI_container.modulate.a -= fade_speed * delta * 10
		if UI_container.modulate.a < 0.0:
			UI_container.modulate.a = 0.0
	
	# Effect pendant le zoom sur le livre :
	# L'écran redevient noir sauf le livre pour faire un focus sur le livre
	if is_zoom_on_book:
		if black_screen2.modulate.a < 1.0:
			black_screen2.modulate.a += fade_speed * delta * 4
			if black_screen2.modulate.a > 1.0:
				black_screen2.modulate.a = 1.0
				livre.texture = preload("res://assets/item/livre-ouvert.png")
				_play_scene(0)
	
	# Avancer les dialogues plus rapidements
	if Input.is_action_just_pressed("ui_accept") and StoryManager.is_playing:
		DialogueUi.advance_or_close()

# Quand le bouton "Jouer" est pressé
func _on_play_button_pressed() -> void:
	emit_signal("start_cinematic", true)
	is_play_button_clicked = true
	
	# IMPORTANT : Lancement de deux fonction synchrone
	# Elles effectue toutes les deux une modification sur le même objet (camera2D) en même temps
	start_camera_transition_move()
	start_camera_transition_zoom()

# Quand le bouton "Parametres" est pressé
func _on_settings_button_pressed() -> void:
	print("Paramètre non-implémenter")

# Quand le bouton "Quitter" est pressé
func _on_quit_play_pressed() -> void:
	get_tree().quit()

# Quand un pnj s'approche de la porfte du chateau,
# On rend le TileMapLayer visible pour que la porte s'ouvre
func _on_porte_chateau_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		tilemap_effect.visible = true

# Inversement, quand il n'y a plus de pnj,
# On rend le TileMapLayer invisble pour que la porte se ferme
func _on_porte_chateau_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		tilemap_effect.visible = false

# Zoom de la camera
func start_camera_transition_zoom():
	var tween = create_tween()
	tween.tween_property(camera_menu, "zoom", Vector2(2.25, 2.25), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# Fait une transition pour suivre les déplacements du pnj principal
func start_camera_transition_move():
	var tween = create_tween()
	tween.tween_property(camera_menu, "position", pnj.global_position, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "_switch_to_gameplay_camera"))

# Change de caméra active
func _switch_to_gameplay_camera():
	camera_pnj.make_current()

# Zoom sur le livre
func _on_zoom_book():
	var tween = create_tween()
	
	# On zoom sur le centre de l'image du livre
	var livre_center = livre.global_position + livre.size * 0.5 * livre.scale
	
	var target_pos = camera_pnj.get_parent().to_local(livre_center)
	
	black_screen2.visible = true
	is_zoom_on_book = true
	
	tween.tween_property(camera_pnj, "position", target_pos, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera_pnj, "zoom", Vector2(100, 100), 4.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# Permet de définir quand le monologue est fini
func _on_monologue_finished(who: String):
	if who != "Narrateur":
		return
	black_screen_1_enabled = false
