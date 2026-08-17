extends Enemy

# --- Configuration ---

const INVULNERABILITY_TIME: float = 0.5

@export var jump_height: float = 5.0
@export var time_to_apex: float = 0.30
@export var move_speed: float = 30.0
@export var jump_cooldown: float = 2.0
@export var knockback_multiplier: float = 2.5

@export var max_health: int = 2
@export var damage: int = 1

# --- State ---

enum State {
	ROAM,
	CHASE,
	HURT,
	DEAD
}

var state: State = State.ROAM
var direction: int = 0 # 1 = Right / -1 = Left
var target: Player = null
var health: int = max_health
var invulnerability_timer: float = 0.0

# --- Référence ---

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $JumpTimer

# --- Physique ---

var gravity:
	get:
		return (2.0 * jump_height) / pow(time_to_apex, 2)
var jump_velocity:
	get:
		return -gravity * time_to_apex

# --- Lifecycle ---

func _ready() -> void:
	jump_timer.wait_time = jump_cooldown
	jump_timer.one_shot = true
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	update_timers(delta)
	handle_movement()
	
	move_and_slide()
	update_animation()

# --- Movement ---

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_movement() -> void:
	if is_dead():
		return
	
	if state == State.HURT:
		await sprite.animation_finished
		if target:
			state = State.CHASE
		else:
			state = State.ROAM
	
	if not is_on_floor():
		return
		
	if not jump_timer.is_stopped():
		velocity.x = 0
		sprite.play("idle")
		return
	
	if state == State.ROAM:
		define_direction_roam()
	else:
		define_direction_chase()
		
	sprite.flip_h = direction == -1
	
	velocity.x = direction * move_speed
	velocity.y = jump_velocity
	
	jump_timer.start()
	sprite.play("jump")

func define_direction_roam() -> void:
	if direction == 0:
		direction = 1 if randf() > 0.5 else -1

func define_direction_chase() -> void:
	if not target:
		return
	
	direction = sign(target.global_position.x - global_position.x)

# --- Combat ---

func take_damage(amount: int) -> void:
	if invulnerability_timer > 0.0:
		return
	
	invulnerability_timer = INVULNERABILITY_TIME
	
	health = max(health - amount, 0) # Bornée par le bas à 0
	
	if health <= 0:
		die()
		return
	
	state = State.HURT
	sprite.play("hurt")

func apply_knockback(source_position: Vector2, knockback_force: Vector2) -> void:
	if invulnerability_timer > 0.0:
		return
	
	var dir: int = sign(global_position.x - source_position.x)
	
	velocity.x = dir * knockback_force.x * knockback_multiplier
	velocity.y = -knockback_force.y * knockback_multiplier

func die() -> void:
	state = State.DEAD
	sprite.play("die")
	velocity = Vector2.ZERO

func is_dead() -> bool:
	return state == State.DEAD

# --- Timers ---

func update_timers(delta: float) -> void:
	if invulnerability_timer > 0.0:
		invulnerability_timer -= delta

# --- Animation ---
func update_animation() -> void:
	if velocity.y > 0 and sprite.animation == "jump":
		sprite.play("fall")

# --- Détéction ---

func _on_wall_detector_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		direction *= -1

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player and not is_dead():
		state = State.CHASE
		target = body

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Player and not is_dead():
		attack_player.emit(damage, global_position)
