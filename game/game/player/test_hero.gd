extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# États possibles
enum DIRECTION {
	LEFT = -1,
	RIGTH = 1,
	NEUTRAL = 0 }

# Constantes
const SPEED: float = 1000.0

# Récupère la direction
func get_direction():
	var direction: DIRECTION = DIRECTION.NEUTRAL
	var value: float = Input.get_axis("ui_left", "ui_right")
	if value < 0.0: # Left
		direction = DIRECTION.LEFT
	elif value > 0.0: # Right
		direction = DIRECTION.RIGTH
	else: # Neutral
		direction = DIRECTION.NEUTRAL
	return direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_deplacement(delta)

func handle_deplacement(delta: float) -> void:
	var dir = get_direction()
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		self.global_position.x += lerp(self.global_position, self.global_position + SPEED * dir * delta, 1.0)
