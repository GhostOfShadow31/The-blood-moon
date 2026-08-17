class_name PlayerAnimationController
extends Node

var player: Player = null
var sprite: AnimatedSprite2D = null

func setup(p_player: Player, p_sprite: AnimatedSprite2D) -> void:
	player = p_player
	sprite = p_sprite
	p_sprite.animation_finished.connect(_on_animation_finished)

# Lit  l'état du joueur et joue les animations
func update() -> void:
	if player.is_attacking:
		play_attack_animation()
		return
	if not player.is_on_floor():
		if player.velocity.y < 0:
			play_jump_animation()
		else:
			play_fall_animation()
	elif player.velocity.x != 0:
		play_run_animation()
	else:
		play_idle_animation()

func play_jump_animation() -> void:
	pass # No animation for the moment
	# Expect animation name: "jump_left" & "jump_right"

func play_fall_animation() -> void:
	pass # No animation for the moment
	# Expect animation name: "fall_left" & "fall_right"

func play_run_animation() -> void:
	if player.facing < 0:
		player.animated_sprite.play("run_left")
	else:
		player.animated_sprite.play("run_right")

func play_idle_animation() -> void:
	if player.facing < 0:
		sprite.play("idle_left")
	else:
		sprite.play("idle_right")

func play_hurt_animation() -> void:
	if player.facing < 0:
		sprite.play("hurt_left")
	else:
		sprite.play("hurt_right")

func play_die_animation() -> void:
	if player.facing < 0:
		sprite.play("die_left")
	else:
		sprite.play("die_right")

func play_attack_animation() -> void:
	if player.attack_facing < 0:
		sprite.play("attack_left")
	else:
		sprite.play("attack_right")

func _on_animation_finished() -> void:
	if sprite.animation == "attack_left" or sprite.animation == "attack_right":
		player.disable_attack_hitbox()
		player.is_attacking = false
