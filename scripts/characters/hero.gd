extends Node
class_name Hero

@onready var sprite: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D

func play_animation(anim_name: String) -> void:
	if sprite.sprite_frames.has_animation(anim_name):
		sprite.play(anim_name)
	else:
		push_warning("WARNING-- Animation inconnue: " + anim_name)


func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play("idle_front") # À modifier ici pour garder en mémoire les directions 
