extends Interactable

const ANIMATION_COOLDOWN: float = 5.0
const INTERACTION_COOLDOWN: float = 5.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var player: Player = null

var animation_timer: float = 0.0
var can_play_hint_animation: bool = false
var interaction_timer: float = 0.0
var can_interact: bool = true

func _process(delta: float) -> void:
	update_timers(delta)
	
	play_hint_animation()

func update_timers(delta: float) -> void:
	if animation_timer > 0.0:
		animation_timer -= delta
		if animation_timer >= 0.0:
			can_play_hint_animation = true
	if interaction_timer > 0.0:
		interaction_timer -= delta
		if interaction_timer >= 0.0:
			can_interact = true

func interact() -> void:
	if not can_interact:
		return
	print(can_interact)
	
	can_interact = false
	interaction_timer = INTERACTION_COOLDOWN
	#print("caca")

func play_hint_animation() -> void:
	if sprite.is_playing() or animation_timer > 0.0:
		return
	
	can_play_hint_animation = false
	sprite.play("hint")
	animation_timer = ANIMATION_COOLDOWN

func _on_interact_zone_body_entered(body: Node2D) -> void:
	if body is not Player or not can_interact:
		return
	
	player = body
	player.interactable = self


func _on_interact_zone_body_exited(body: Node2D) -> void:
	if body is not Player:
		return
	
	if player != null and player.interactable == self:
		player.interactable = null
	player = null


func _on_hint_zone_body_entered(body: Node2D) -> void:
	if body is not Player or not can_interact:
		return
	
	can_play_hint_animation = true


func _on_hint_zone_body_exited(body: Node2D) -> void:
	if body is not Player:
		return
	
	can_play_hint_animation = false
