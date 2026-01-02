extends Node
class_name Hero

@onready var character_body_2D: CharacterBody2D = $CharacterBody2D

func is_moving() -> bool:
	return character_body_2D.get_move()

func stop_hero(anim_name: String) -> void:
	character_body_2D.set_can_move(false, anim_name)
	
func allow_hero() -> void:
	character_body_2D.set_can_move(true, null)

func _physics_process(delta: float) -> void:
	# Calcul du déplacement
	character_body_2D._hero_physics(delta)
	
	# On applique le déplacement au parent
	self.global_position += character_body_2D.get_motion_delta()
	
	# On remet le body à l'origine
	character_body_2D.position = Vector2.ZERO
