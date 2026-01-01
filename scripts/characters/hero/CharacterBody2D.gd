extends CharacterBody2D

@export var speed: float = 64.0
@export var gravity: float = 900.0
@export var jump_force: float = sqrt(2 * gravity * 48) # 48 pixels pour hauteur du saut
@export var jump_cut_multiplier: float = 0.5

@export var coyote_time: float = 0.08 # Temps pour povoir sauter après avoir quitter le sol
var coyote_timer: float = 0.0

@export var jump_buffer_time: float = 0.1 # Temps pour appuyer sur la touche de saut pendant un saut pour en faire un second
var jump_buffer: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var facing := 0 # Droite: 1, Gauche: -1
var can_move: bool = true
var blocking_animation: String = ""
var current_animation: String = ""
var last_motion: Vector2 = Vector2.ZERO

enum State {IDLE, WALK, AIR, BLOCKING}
var state: State = State.IDLE

func _hero_physics(delta: float) -> void:
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
		facing = sign(direction)
	
	updateState()
	play_animation()
	move_and_slide()
	last_motion = self.velocity * delta

func get_motion_delta() -> Vector2:
	return last_motion

func updateState() -> void:
	# Etat du hero
	if not can_move:
		state = State.BLOCKING
	elif not is_on_floor():
		state = State.AIR
	elif (abs(self.velocity.x) > 0.1):
		state = State.WALK
	else:
		state = State.IDLE

func get_direction_suffix() -> String:
	return "right" if facing == 1 else "left"

func play_animation() -> void:
	var dir :String = get_direction_suffix()
	var next_animation: String = ""
	
	match state:
		State.IDLE:
			next_animation = "idle_" + dir
		State.WALK:
			next_animation = "walk_" + dir
		State.AIR:
			next_animation = "idle_" + dir
		State.BLOCKING:
			next_animation = blocking_animation
	
	if next_animation != current_animation:
		current_animation = next_animation
		sprite.play(current_animation)

func get_move() -> bool:
	return can_move

func set_can_move(value: bool, anim_name = "") -> void:
	if not value and anim_name != null:
		blocking_animation = anim_name
	can_move = value
