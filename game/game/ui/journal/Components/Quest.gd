class_name Quest_UI
extends Control

const TEXT_COLOR: Dictionary[String, Color] = {
	"default": Color("#462d2f"),
	"selected": Color("#4e2e2b")
}
const TEXT_STATE: Dictionary[Quest.State, String] = {
	Quest.State.TRACKED: "Tracked",
	Quest.State.COMPLETED: "Completed",
	Quest.State.IN_PROGRESS: "In Progress"
}

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var title: Label = $AnimatedSprite2D/QuestTitle
@onready var state: Label = $AnimatedSprite2D/QuestState

var quest: Quest

# Instancie avec une ressource Quest
func set_object(q: Quest) -> void:
	quest = q
	title.text = quest.title

# Retourne la quête
func get_object() -> Quest:
	return quest

# Définit ou non si cette quête est seléctionnée
func play(anim_name: String) -> void:
	match anim_name:
		"default":
			sprite.play("default")
			title.add_theme_color_override("font_color", TEXT_COLOR["default"])
		"selected":
			sprite.play("selected")
			title.add_theme_color_override("font_color", TEXT_COLOR["selected"])

# Définit l'état de la quête qui sera affiché
func set_state(s: Quest.State) -> void:
	state.text = TEXT_STATE[s]
