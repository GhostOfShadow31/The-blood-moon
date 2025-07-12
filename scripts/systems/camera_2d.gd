extends Camera2D

const SMOOTH_SPEED := 0.02  # réduit la vitesse de lerp

var target_position := Vector2.ZERO

func set_target_position(pos: Vector2) -> void:
	target_position = pos

func _process(_delta):
	self.position = lerp(self.position, target_position, SMOOTH_SPEED)
