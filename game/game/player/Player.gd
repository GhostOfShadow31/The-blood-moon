class_name Player
extends CharacterBody2D

func _ready() -> void:
	anim_controller.setup(self, animated_sprite)

func _physics_process(delta: float) -> void:
	update_timers(delta)
	if not is_dead() and not is_knocked_back:
		handle_interaction()
		handle_attack()
		
		handle_movement()
		handle_jump()
	
	handle_gravity(delta)
	
	move_and_slide()
	
	update_animation()

# =========================
# MOVEMENT
# =========================

@export var move_speed: float = 90.0
var facing: int = 1

func handle_movement() -> void:
	var direction: float = Input.get_axis("ui_left", "ui_right")
	
	velocity.x = direction * move_speed
	
	if direction != 0:
		facing = sign(direction)

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

# =========================
# TIMER
# =========================

const COYOTE_TIME: float = 0.08
const JUMP_BUFFER_TIME: float = 0.10
const KNOCKBACK_TIME: float = 0.25
const INVULNERABILITY_TIME: float = 0.5

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var knockback_timer: float = 0.0
var invulnerability_timer: float = 0.0

func update_timers(delta: float) -> void:
	if invulnerability_timer > 0.0:
		invulnerability_timer -= delta
	if is_knocked_back:
		knockback_timer -= delta
		if knockback_timer <= 0:
			is_knocked_back = false
	
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
	
	jump_buffer_timer -= delta

# =========================
# JUMP
# =========================

@export var jump_height: float = 50.0
@export var time_to_apex: float = 0.40
@export var jump_multiplier: float = 0.25
var gravity:
	get:
		return (2.0 * jump_height) / pow(time_to_apex, 2)
var jump_speed: 
	get:
		return gravity * time_to_apex

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

# =========================
# INTERACTION
# =========================

var interactable: Interactable = null

func handle_interaction() -> void:
	if Input.is_action_pressed("ui_interact") and interactable:
		interactable.interact()

# =========================
# ATTACK
# =========================

signal attack_enemy(enemy: Enemy, damage: int)

@onready var hitbox_right: CollisionShape2D = $HitBox/Right
@onready var hitbox_left: CollisionShape2D = $HitBox/Left

@export var has_sword: bool = false
@export var damage: int = 1
@export var knockback_power: Vector2 = Vector2(10, 10)
var is_attacking: bool = false
var attack_buffer_locked: bool = false
var attack_facing: int = 1

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
	
	enable_attack_hitbox()
	anim_controller.play_attack_animation()

func enable_attack_hitbox() -> void:
	hitbox_right.disabled = attack_facing != 1
	hitbox_left.disabled = attack_facing != -1

func disable_attack_hitbox() -> void:
	hitbox_right.disabled = true
	hitbox_left.disabled = true

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Enemy:
		attack_enemy.emit(body, damage)

# =========================
# ANIMATION
# =========================
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var anim_controller: PlayerAnimationController = PlayerAnimationController.new()

func update_animation() -> void:
	anim_controller.update()

# =========================
# KNOCKBACK
# =========================

@export var knockback_force: Vector2 = Vector2(150, 150)
var is_knocked_back: bool = false

func apply_knockback(source_position: Vector2) -> void:
	is_knocked_back = true
	knockback_timer = KNOCKBACK_TIME
	
	var direction: int = sign(global_position.x - source_position.x)
	
	velocity.x = direction * knockback_force.x
	velocity.y = -knockback_force.y

# =========================
# HEALTH
# =========================

@onready var hurtbox: CollisionShape2D = $HurtBox/CollisionShape2D

@export var max_health: int = 5

enum State {
	ALIVE,
	DEAD
}

var state: State = State.ALIVE
var health: int = max_health

func take_damage(amount: int) -> void:
	if !can_take_damage():
		return
	
	invulnerability_timer = INVULNERABILITY_TIME
	health = max(health - amount, 0) # Bornée par le bas à 0
	print("PV: ", health)
	
	if health <= 0:
		state = State.DEAD
		die()
		return
	
	anim_controller.play_hurt_animation()

func can_take_damage() -> bool:
	return false if invulnerability_timer > 0.0 else true

func recover(to_position: Vector2) -> void:
	global_position = to_position
	velocity = Vector2.ZERO

func set_hp(value: int) -> void:
	health = value if value < max_health else max_health
	state = State.ALIVE
	print("Seuil de PV: ", health)

func get_health() -> int:
	return health

func is_dead() -> bool:
	return state == State.DEAD

func die() -> void:
	anim_controller.play_die_animation()

func get_hurtbox() -> CollisionShape2D:
	return hurtbox
