extends Camera2D

const SMOOTH_SPEED := 0.02  # réduit la vitesse de lerp

# Donne à la camera les coordonées ou elle doit se déplacer
var target_position := Vector2.ZERO

var player # Récupère le joueur
var is_following_player := false

func _ready() -> void:
	for child in self.get_parent().get_children():
		if child.name == "Player":
			player = child

func set_target_position(pos: Vector2) -> void:
	target_position = pos

func set_position_at_start(pos: Vector2) -> void:
	self.position = pos
	target_position = pos

func follow_player(follow: bool) -> void:
	is_following_player = follow

func _process(_delta):
	# lerp permet de faire un mouvement lisse (!= cassure)
	if is_following_player:
		self.position = player.global_position
	else:
		self.position = lerp(self.position, target_position, SMOOTH_SPEED)
