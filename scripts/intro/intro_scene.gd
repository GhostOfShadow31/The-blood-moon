extends Node

@onready var mainAnimation: AnimationPlayer = $MainAnimation
@onready var pulseAnimation: AnimationPlayer = $PulseAnimation
@onready var camera_focus: Marker2D = $Camera_focus

var is_intro_start_finished: bool = false
var intro_dialogues: Array = []

signal intro_finished
signal request_dialogue_ui(dialogues: Array)
signal request_fade_in_out(duration_fade: float, duration_active: float)

func _ready():	
	var file = FileAccess.open("res://data/scenes.json", FileAccess.READ)
	if file:
		var data = file.get_as_text()
		intro_dialogues = JSON.parse_string(data)["intro_scene"]
		file.close()
	else:
		push_error("ERREUR-- Impossible de charger /data/scenes.json")
	
	start_intro()

func start_intro() -> void:
	mainAnimation.play("camera_up")
	pulseAnimation.play("pulse")
	
	# Petit pause avant l'ouverture du dialogue
	await get_tree().create_timer(1.0).timeout
	emit_signal("request_dialogue_ui", intro_dialogues)

func _on_main_animation_animation_finished(anim_name: StringName) -> void:
	play_next_animation(anim_name)

func play_next_animation(anim_name: StringName) -> void:
	match anim_name:
		"menu_fade_out":
			mainAnimation.play("intro_start")
		"camera_up":
			mainAnimation.play("title_fade")
		"title_fade":
			emit_signal("request_fade_in_out", 2.5, 10.0)
			await get_tree().create_timer(10.0).timeout
			pulseAnimation.stop()
			emit_signal("intro_finished")
			self.visible = false

func get_camera_focus() -> Marker2D:
	return camera_focus
