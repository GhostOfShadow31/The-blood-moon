extends CharacterBody2D

@export var speed := 300.0  # Vitesse de déplacement
var last_direction := Vector2(0, 1) # Par défaut regarde vers le bas (idle_down)

@onready var animation_tree = $AnimatedSprite2D/AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

var is_sleeping := true

func _ready():
	animation_tree.active = true
	animation_state.travel("sleep")

func _process(_delta):
	if is_sleeping:
		if Input.is_action_just_pressed("ui_accept"):
			_start_wake_up_sequence()
	elif not StoryManager.is_playing:
		var input_vector := Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
		# Empêcher déplacement diagonal : priorité axe X si différent de zéro sinon axe Y
		if input_vector.x != 0:
			input_vector.y = 0
		elif input_vector.y != 0:
			input_vector.x = 0

		# Normaliser pour vitesse constante
		input_vector = input_vector.normalized()
		
		if input_vector == Vector2.ZERO:
			# Personnage immobile : joue idle dans la dernière direction
			animation_tree.set("parameters/Move/blend_position", last_direction * 0.9)
		else:
			# Personnage bouge : on joue walk et on met à jour la dernière direction
			animation_tree.set("parameters/Move/blend_position", input_vector)
			last_direction = input_vector
		
			# Déplace le personnage
			velocity = input_vector * speed
			move_and_slide()
	else:
		animation_tree.set("parameters/Move/blend_position", last_direction * 0.9)

func _start_wake_up_sequence() -> void:
	# Lance un timer (await) avant d’exécuter l’animation get_up
	await get_tree().create_timer(1.0).timeout
	# Passe à get_up
	animation_state.travel("get_up")
	# Attends que l’animation get_up soit finie
	await get_tree().create_timer(1.0).timeout
	# Passe à Move
	animation_state.travel("Move")
	is_sleeping = false
