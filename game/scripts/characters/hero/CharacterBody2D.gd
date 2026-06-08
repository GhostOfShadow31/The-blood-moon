extends CharacterBody2D

### -- Variables exportées -- ###
@export var speed: float = 64.0
@export var gravity: float = 900.0
@export var jump_force: float = sqrt(2 * gravity * 48) # 48 pixels pour hauteur du saut
@export var jump_cut_multiplier: float = 0.5

# -- Knockback -- #
@export var knockback_force: Vector2 = Vector2(30 * sqrt(26), 30 * sqrt(26))
@export var knockback_duration: float = 0.15

# -- Pouvoir sauter après avoir quitté le sol -- #
@export var coyote_time: float = 0.08
var coyote_timer: float = 0.0

# -- Pouvoir anticiper le second saut -- #
@export var jump_buffer_time: float = 0.1
var jump_buffer: float = 0.0

### -- Noeud d'animation -- ###
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

### -- Etats possibles -- ###
enum Stance { UNARMED, ARMED }
enum Facing { LEFT, RIGHT }
enum MoveState { IDLE, WALK, ATTACK, AIR, BLOCKED }

### -- Variables internes -- ###
var stance: Stance = Stance.UNARMED
var facing: Facing = Facing.LEFT
var move_state: MoveState = MoveState.IDLE

var knockback_timer: float = 0.0
var knockback_velocity: Vector2 = Vector2.ZERO

var can_move: bool = true
var forced_animation: String = ""
var current_animation: String = ""
var is_dead: bool = false

# -- Déplacer le noeud racine de la scène -- #
var last_motion: Vector2 = Vector2.ZERO

### -- Mettre à jour l'état de mouvement -- ###
func update_move_state() -> void:
	if not can_move:
		move_state = MoveState.BLOCKED
	
	if not is_on_floor():
		move_state = MoveState.AIR
		return
	
	if (abs(self.velocity.x) > 0.1):
		move_state = MoveState.WALK
	else:
		move_state = MoveState.IDLE

### -- Animations -- ###
# -- Récupérer les informations sur le nom de l'animation -- #
func get_animation_key() -> String:
	match move_state:
		MoveState.IDLE:
			return "idle"
		MoveState.WALK:
			return "walk"
		MoveState.ATTACK:
			return "attack"
		MoveState.AIR:
			return "idle" # Changer ici pour animation dans les airs
		MoveState.BLOCKED:
			return "" # Sera géré ailleurs (animations forcées)
	return ""

func get_animation_direction() -> String:
	return "right" if facing == Facing.RIGHT else "left"

func get_animation_stance() -> String:
	return "unarmed" if stance == Stance.UNARMED else "armed"

# -- Construire le nom de l'animation -- #
func build_animation_name(anim_key: String) -> String:
	if anim_key == "":
		return ""
	
	var prefix: String = get_animation_stance()
	var direction: String = get_animation_direction()
	
	return prefix + "_" + anim_key + "_" + direction

# -- Jouer l'animation -- #
func play_animation() -> void:
	# 1. Animation forcée prioritaire
	if forced_animation != "":
		if sprite.animation != forced_animation:
			sprite.play(forced_animation)
		return
	
	# 2. Pipeline normal
	var anim_key: String = get_animation_key()
	var anim_name: String = build_animation_name(anim_key)
	
	if anim_name == "":
		return
	
	if anim_name != current_animation:
		current_animation = anim_name
		sprite.play(current_animation)

func play_forced_animation(anim_name: String, lock: bool = true) -> void:
	forced_animation = anim_name
	can_move = not lock
	
	if sprite.animation != anim_name:
		current_animation = anim_name
		sprite.play(current_animation)

func clear_forced_animation() -> void:
	forced_animation = ""
	can_move = true

func die() -> void:
	if is_dead:
		return
	
	is_dead = true
	can_move = false
	self.velocity = Vector2.ZERO
	
	var animation: String = build_animation_name("death")
	
	play_forced_animation(animation, true)

### -- Physique du héro -- ###
func _hero_physics(delta: float) -> void:
	# Gestion du knockback
	if knockback_timer > 0.0:
		knockback_timer -= delta
		
		self.velocity = knockback_velocity
		self.velocity.y += gravity * delta
		
		move_and_slide()
		
		if knockback_timer <= 0.0:
			can_move = true
		
		last_motion = self.velocity * delta
		return
	
	if is_dead or not can_move:
		move_and_slide()
		last_motion = self.velocity * delta
		return
	
	# Gestion du buffer jump
	if jump_buffer > 0.0:
		jump_buffer -= delta
	
	# Gravité
	if not is_on_floor():
		self.velocity.y += gravity * delta
		coyote_timer -= delta
	else:
		self.velocity.y = 0
		coyote_timer = coyote_time
	
	# Mouvement horizontal et Saut
	var direction: float = 0.0
	if can_move:
		direction = Input.get_axis("ui_left", "ui_right")
		
		# Saut
		if Input.is_action_just_pressed("ui_accept"):
			jump_buffer = jump_buffer_time
		
		if jump_buffer > 0.0 and coyote_timer > 0.0:
			self.velocity.y = -jump_force
			coyote_timer = 0.0
			jump_buffer = 0.0
			
		# Relachement du saut
		if Input.is_action_just_released("ui_accept") and self.velocity.y < 0:
			self.velocity.y *= jump_cut_multiplier
	
	self.velocity.x = direction * speed
		
	# Se souvenir de la direction
	if direction != 0:
		facing = Facing.LEFT if sign(direction) < 0 else Facing.RIGHT
	
	update_move_state()
	play_animation()
	
	move_and_slide()
	last_motion = self.velocity * delta

### - Knockback -- ###
func apply_knockback(from_position: Vector2) -> void:
	can_move = false
	
	var direction = sign(global_position.x - from_position.x)
	if direction == 0:
		direction = -1 if facing == Facing.RIGHT else 1
	
	knockback_velocity = Vector2(
		direction * knockback_force.x,
		-knockback_force.y
	)
	
	knockback_timer = knockback_duration

### -- Attaquer -- ###
func start_attack() -> void:
	if forced_animation == "":
		match facing:
			Facing.RIGHT:
				play_forced_animation("armed_attack_right", false)
			Facing.LEFT:
				play_forced_animation("armed_attack_left", false)
			_:
				return
		await sprite.animation_finished
		clear_forced_animation()

### -- Fonctions utilitaires -- ###
func get_move() -> bool:
	return can_move

func set_can_move(value: bool, anim_type: String = "") -> void:
	var animation: String
	match anim_type:
		"hurt":
			animation = build_animation_name(anim_type)
		"death":
			animation = build_animation_name(anim_type)
		"wake_up":
			animation = anim_type
		"sleep":
			animation = anim_type
		_:
			animation = ""
	
	can_move = value

	if not value and animation != "":
		play_forced_animation(animation, true)
	elif value:
		# Débloque l'animation forcée si on reprend le contrôle
		forced_animation = ""

# -- Déplacer le noeud racine de la scène -- #
func get_motion_delta() -> Vector2:
	return last_motion

# -- Obetnir la direction du sprite -- #
func get_direction() -> int:
	return -1 if facing == Facing.LEFT else 1
