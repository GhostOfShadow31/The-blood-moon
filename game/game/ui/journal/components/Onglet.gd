extends Control

@export var sf: SpriteFrames

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if sf == null:
		assert(false, "Need a sprite frame for: " + name)
	
	sprite.sprite_frames = sf

# Joue une animation donnée
func play(anim_name: String) -> void:
	sprite.play(anim_name)
