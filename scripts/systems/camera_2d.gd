extends Camera2D

const SMOOTH_SPEED := 0.02  # réduit la vitesse de lerp

# Donne à la camera les coordonées ou elle doit se déplacer
var target_position := Vector2.ZERO

func set_target_position(pos: Vector2) -> void:
	target_position = pos

func _process(_delta):
	# lerp permet de faire un mouvement lisse (!= cassure)
	self.position = lerp(self.position, target_position, SMOOTH_SPEED)
