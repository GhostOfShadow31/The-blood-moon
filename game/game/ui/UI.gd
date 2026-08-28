extends CanvasLayer

const OFFSET_JOURNAL: Vector2 = Vector2(0.0, 170.0)

@onready var journal: Control = $Journal
@onready var feedback: Control = $Feedback

var is_inventory_visible: bool = false

# Détermine si le journal doit être affiché ou non
func toggle_journal() -> void:
	is_inventory_visible = not is_inventory_visible
	if is_inventory_visible:
		show_journal()
	else:
		hide_journal()

# Affiche le journal
func show_journal() -> void:
	journal.set_active(true)
	var tween := create_tween()
	tween.tween_property(journal, "global_position", journal.global_position - OFFSET_JOURNAL, 0.15)

# Masque le journal
func hide_journal() -> void:
	journal.set_active(false)
	var tween := create_tween()
	tween.tween_property(journal, "global_position", journal.global_position + OFFSET_JOURNAL, 0.15)

# Consomme unn objet consommable et renvoie un tableau des effets
func consume(item: Item) -> Array[ItemEffect]:
	return journal.consume(item)

# Affiche un feedback lors de la récupération d'un objet
func get_feedback(items: Dictionary) -> void:
	feedback.show_loot(items)
