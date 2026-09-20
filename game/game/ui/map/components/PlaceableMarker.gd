class_name PlaceableMarker
extends Marker2D

enum MARKER_TYPE {
	TERRACOTA,
	FOAM,
	SLATE,
	ASH
}

@onready var sprite: AnimatedSprite2D = $MarkerSprite
@onready var selector: AnimatedSprite2D = $SelectorSprite

var current_marker_type: MARKER_TYPE = MARKER_TYPE.TERRACOTA

func _ready() -> void:
	selector.play("default")

# Switch vers le marqueur suivant
func next_marker() -> void:
	current_marker_type = (current_marker_type + 1) % MARKER_TYPE.size() as MARKER_TYPE
	set_marker(current_marker_type)

# Switch vers le marqueur précédent
func previous_marker() -> void:
	current_marker_type = (current_marker_type + MARKER_TYPE.size() - 1) % MARKER_TYPE.size() as MARKER_TYPE
	set_marker(current_marker_type)

# Choisit l'apparence du marqueur et masque le sélecteur
func set_marker(type: MARKER_TYPE) -> void:
	match type:
		MARKER_TYPE.TERRACOTA:
			sprite.play("terracota")
		MARKER_TYPE.FOAM:
			sprite.play("foam")
		MARKER_TYPE.SLATE:
			sprite.play("slate")
		MARKER_TYPE.ASH:
			sprite.play("ash")

# Masque le sélecteur
func hide_selector(value: bool) -> void:
	selector.visible = not value
