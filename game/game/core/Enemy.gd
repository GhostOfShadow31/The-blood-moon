class_name Enemy
extends CharacterBody2D

@warning_ignore("unused_signal")
signal attack_player(damage: int, from: Vector2)

# Un ennemi peut prendre des dégâts
func take_damage(_amount: int) -> void:
	assert(false, "Must be implemented")

# Recevoir un knockback
func apply_knockback(_source_position: Vector2, _knockback_force: Vector2) -> void:
	assert(false, "Must be implemented")

# Savoir si l'entité est morte
func is_dead() -> bool:
	assert(false, "Must be implemented")
	return false
