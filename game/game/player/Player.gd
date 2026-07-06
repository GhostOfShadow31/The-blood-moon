class_name Player
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Déplacement
@export var move_speed: float = 90.0

# Saut
@export var jump_height: float = 50.0
@export var time_to_apex: float = 0.40
@export var jump_multiplier: float = 0.25
var gravity:
	get:
		return (2.0 * jump_height) / pow(time_to_apex, 2)
var jump_speed: 
	get:
		return gravity * time_to_apex

# PV
@export var max_health: int = 5
var health: int = max_health

# KnockBack
@export var knockback_force: Vector2 = Vector2(150, 150)
var is_knocked_back: bool = false

# Confort
const COYOTE_TIME: float = 0.08
const JUMP_BUFFER_TIME: float = 0.10
const KNOCKBACK_TIME: float = 0.15

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var knockback_timer: float = 0.0

# Direction
var facing: int = 1

# Interaction
var interactable: Interactable = null

# Combat
var has_sword: bool = false
var is_attacking: bool = false
var attack_buffer_locked: bool = false
var attack_facing: int = 1

func _physics_process(delta: float) -> void:
	update_timers(delta)
	
	handle_interaction()
	handle_attack()
	
	handle_gravity(delta)
	handle_movement()
	handle_jump()
	
	move_and_slide()
	
	update_animation()

func handle_movement() -> void:
	if is_knocked_back:
		return
	
	var direction: float = Input.get_axis("ui_left", "ui_right")
	
	velocity.x = direction * move_speed
	
	if direction != 0:
		facing = sign(direction)

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func update_timers(delta: float) -> void:
	if is_knocked_back:
		knockback_timer -= delta
		if knockback_timer <= 0:
			is_knocked_back = false
	
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
	
	jump_buffer_timer -= delta

func handle_jump() -> void:
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	
	if can_jump():
		velocity.y = -jump_speed
		
		coyote_timer = 0.0
		jump_buffer_timer = 0.0
		
	if Input.is_action_just_released("ui_accept") and self.velocity.y < 0:
		self.velocity.y *= jump_multiplier

func can_jump() -> bool:
	return (jump_buffer_timer > 0.0 and coyote_timer > 0.0)

func handle_interaction() -> void:
	if Input.is_action_pressed("ui_interact") and interactable:
		interactable.interact()

func handle_attack() -> void:
	if Input.is_action_pressed("ui_attack"):
		try_attack()
	
	if Input.is_action_just_released("ui_attack"):
		attack_buffer_locked = false

func try_attack() -> void:
	if attack_buffer_locked or is_attacking or not has_sword:
		return
	is_attacking = true
	attack_buffer_locked = true
	attack_facing = facing
	play_attack_animation()

func update_animation() -> void:
	if is_attacking:
		play_attack_animation()
		return
	if not is_on_floor():
		if velocity.y < 0:
			play_jump_animation()
		else:
			play_fall_animation()
	elif velocity.x != 0:
		play_run_animation()
	else:
		play_idle_animation()

func play_jump_animation() -> void:
	pass # No animation for the moment
	# Expect animation name: "jump_left" & "jump_right"

func play_fall_animation() -> void:
	pass # No animation for the moment
	# Expect animation name: "fall_left" & "fall_right"

func play_run_animation() -> void:
	if facing < 0:
		animated_sprite.play("run_left")
	else:
		animated_sprite.play("run_right")

func play_idle_animation() -> void:
	if facing < 0:
		animated_sprite.play("idle_left")
	else:
		animated_sprite.play("idle_right")

func play_hurt_animation() -> void:
	if facing < 0:
		animated_sprite.play("hurt_left")
	else:
		animated_sprite.play("hurt_right")

func play_die_animation() -> void:
	if facing < 0:
		animated_sprite.play("die_left")
	else:
		animated_sprite.play("die_right")

func play_attack_animation() -> void:
	if attack_facing < 0:
		animated_sprite.play("attack_left")
	else:
		animated_sprite.play("attack_right")

func take_damage(damage: int, source_position: Vector2) -> void:
	health -= damage
	
	play_hurt_animation()
	apply_knockback(source_position)
	
	if health <= 0:
		die()

func apply_knockback(source_position: Vector2) -> void:
	is_knocked_back = true
	knockback_timer = KNOCKBACK_TIME
	
	var direction: int = sign(global_position.x - source_position.x)
	
	velocity.x = direction * knockback_force.x
	velocity.y = -knockback_force.y

func die() -> void:
	play_die_animation()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "attack_left" or animated_sprite.animation == "attack_right":
		is_attacking = false
