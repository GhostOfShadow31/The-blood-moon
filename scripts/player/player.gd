extends CharacterBody2D

@export var speed := 300.0  # Vitesse de déplacement
var last_direction := "Down" # Par défaut regarde vers le bas (idle_down)

@onready var animation = $AnimatedSprite2D

var is_sleeping := false

func _ready():
	var parent = get_parent()
	parent.player_position.connect(_set_global_position)
	if parent.name == "Grotte":
		is_sleeping = true
		animation.play("sleep")
	else:
		animation.play("idle_down")

func _process(_delta):
	# Si le joueur est entrain de dormir
	if is_sleeping:
		if Input.is_action_just_pressed("ui_accept"):
			_start_wake_up_sequence()
	
	# Si il n'y a pas d'histoire en cours
	elif not StoryManager.is_playing:
		# Si l'inventaire n'est pas visible
		if not Inventaire.is_inventory_active:
			# On peut se déplacer
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
				_play_wait_sequence(last_direction)
			else:
				# Personnage bouge : on joue walk et on met à jour la dernière direction
				_play_walk_sequence(input_vector)
			
				# Déplace le personnage
				velocity = input_vector * speed
				move_and_slide()
			
			# Si le joueur appui sur la touche <E>
			if Input.is_action_just_pressed("ui_e"):
				# On affiche l'inventaire
				Inventaire._show()
				_play_wait_sequence(last_direction)
		# Si l'inventaire est visible
		else:
			# Cliquer sur la touche <E> ferme l'inventaire
			if Input.is_action_just_pressed("ui_e"):
				Inventaire._hide()
	# Si le joueur ne bouge pas, on fait l'animation idle dans la dernière direction
	else:
		_play_wait_sequence(last_direction)

# Définit la position du joueur quand il entre dans la zone
func _set_global_position(pos: Vector2):
	global_position = pos

# Animation de réveil
func _start_wake_up_sequence() -> void:
	# Lance un timer (await) avant d’exécuter l’animation get_up
	await get_tree().create_timer(1.0).timeout
	# Passe à get_up
	animation.stop()
	animation.play("get_up")
	# Attends que l’animation get_up soit finie
	await animation.animation_finished
	is_sleeping = false

func _play_wait_sequence(dir: String) -> void:
	if dir == "Down":
		animation.play("idle_down")
	elif dir == "Up":
		animation.play("idle_up")
	elif dir == "Left":
		animation.play("idle_left")
	elif dir == "Right":
		animation.play("idle_right")
	else:
		push_error("dernière position inconnue: ", dir)

func _play_walk_sequence(dir: Vector2) -> void:
	if dir == Vector2.DOWN:
		animation.play("walk_down")
	elif dir == Vector2.UP:
		animation.play("walk_up")
	elif dir == Vector2.LEFT:
		animation.play("walk_left"	)
	elif dir == Vector2.RIGHT:
		animation.play("walk_right")
	else:
		push_error("direction inconnue: ", dir)
	
