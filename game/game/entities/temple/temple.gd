extends Node2D

@onready var sprite_back: AnimatedSprite2D = $BackAnimatedSprite2D
@onready var sprite_front: AnimatedSprite2D = $FrontAnimatedSprite2D
@onready var light_effect: PointLight2D = $PointLight2D

enum State {
	IDLE_ACTIVATE,
	IDLE_DEACTIVATE,
	ACTIVATE
}

var STATE_TO_ANIM: Dictionary = {
	State.IDLE_ACTIVATE: "idle_activate",
	State.IDLE_DEACTIVATE: "idle_deactivate",
	State.ACTIVATE: "activate",
}

var current_animation: String
var is_activate: bool = false

func _ready() -> void:
	light_effect.energy = 0.0
	
	current_animation = STATE_TO_ANIM[State.IDLE_DEACTIVATE]
	sprite_back.play(current_animation)
	sprite_front.play(current_animation)

func play_animation(state: State) -> void:
	current_animation = STATE_TO_ANIM[state]
	sprite_back.play(current_animation)
	sprite_front.play(current_animation)

func activation() -> void:
	if not is_activate:
		sprite_back.stop()
		sprite_front.stop()
		
		current_animation = STATE_TO_ANIM[State.ACTIVATE]
		sprite_back.play(current_animation)
		sprite_front.play(current_animation)
		show_light_effect()
		
		await sprite_back.animation_finished
		await sprite_front.animation_finished
		
		current_animation = STATE_TO_ANIM[State.IDLE_ACTIVATE]
		sprite_back.play(current_animation)
		sprite_front.play(current_animation)
		is_activate = true

func is_activated() -> bool:
	return is_activate

func get_current_animation() -> String:
	return current_animation

func _on_activation_zone_body_entered(body: Node2D) -> void:
	if body.get_parent() is Player:
		activation()

func show_light_effect() -> void:
	var tween = create_tween()
	tween.tween_property(light_effect, "energy", 1.0, 1.0)
