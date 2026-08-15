class_name Temple
extends Node2D

const IDLE_ACTIVATE: String = "idle_activate"
const IDLE_DEACTIVATE: String = "idle_deactivate"
const ACTIVATE: String = "activate"

@onready var sprite_front: AnimatedSprite2D = $FrontAnimatedSprite2D
@onready var sprite_back: AnimatedSprite2D = $BackAnimatedSprite2D
@onready var light_effect: PointLight2D = $PointLight2D

var activated: bool = false

func _ready() -> void:
	light_effect.energy = 0.0
	play(IDLE_DEACTIVATE)

# =========================
# ANIMATION & EFFET
# =========================

func play(animation_name: String) -> void:
	sprite_front.play(animation_name)
	sprite_back.play(animation_name)

func stop() -> void:
	sprite_front.stop()
	sprite_back.stop()

func show_light_effect() -> void:
	var tween = create_tween()
	tween.tween_property(light_effect, "energy", 1.0, 1.0)

# =========================
# DETECTION
# =========================

func _on_activation_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		activate()

# =========================
# ACTIVATION
# =========================

func activate() -> void:
	if activated:
		return
	
	activated = true
	
	show_light_effect()
	
	play(ACTIVATE)
	await sprite_front.animation_finished
	
	play(IDLE_ACTIVATE)

# =========================
# INFORMATION
# =========================

func is_activated() -> bool:
	return activated

func get_spawn_position() -> Vector2:
	return global_position
