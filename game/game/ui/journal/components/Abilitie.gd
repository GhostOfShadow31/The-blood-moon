class_name Ability_UI
extends Control

const TEXT_COLOR: Dictionary[String, Color] = {
	"default": Color("#462d2f"),
	"selected": Color("#4e2e2b")
}

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ability_name: Label = $AnimatedSprite2D/AbilityTitle

var ability: Ability

# Instancie avec une ressource Ability
func set_object(a: Ability) -> void:
	ability = a
	ability_name.text = ability.abilitiy_name

# Retourne la capacité
func get_object() -> Ability:
	return ability

# Définit ou non si cette quête est seléctionnée
func play(anim_ability_name: String) -> void:
	match anim_ability_name:
		"default":
			sprite.play("default")
			ability_name.add_theme_color_override("font_color", TEXT_COLOR["default"])
		"selected":
			sprite.play("selected")
			ability_name.add_theme_color_override("font_color", TEXT_COLOR["selected"])
