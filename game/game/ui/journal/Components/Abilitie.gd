class_name Abilitie_UI
extends Control

const TEXT_COLOR: Dictionary[String, Color] = {
	"default": Color("#462d2f"),
	"selected": Color("#4e2e2b")
}

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var abilitie_name: Label = $AnimatedSprite2D/AbilitieTitle

var abilitie: Abilitie

# Instancie avec une ressource Abilitie
func set_object(a: Abilitie) -> void:
	abilitie = a
	abilitie_name.text = abilitie.abilities_name

# Retourne la capacité
func get_object() -> Abilitie:
	return abilitie

# Définit ou non si cette quête est seléctionnée
func play(anim_abilitie_name: String) -> void:
	match anim_abilitie_name:
		"default":
			sprite.play("default")
			abilitie_name.add_theme_color_override("font_color", TEXT_COLOR["default"])
		"selected":
			sprite.play("selected")
			abilitie_name.add_theme_color_override("font_color", TEXT_COLOR["selected"])
