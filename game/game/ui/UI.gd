extends CanvasLayer

const OFFSET_JOURNAL: Vector2 = Vector2(0.0, 170.0)

@onready var journal: Control = $Journal

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


# Debug / Test
@export var items: Array[Item] = []
@export var quests: Array[Quest] = []

func _ready() -> void:	
	journal.add_consumable(items[0], 5)
	journal.add_consumable(items[1], 2)
	
	journal.start()
	
	# Collectibles
	GameData.set_data("aspen_collected", true)
	
	# Quests
	journal.quests.register_quest(quests[0])
	journal.quests.register_quest(quests[1])
	journal.quests.validate_clue(quests[1], 0)
	journal.quests.validate_clue(quests[1], 1)
	journal.quests.validate_clue(quests[1], 2)
	journal.quests.set_quest_state(quests[1], Quest.State.COMPLETED)
	
	# Bestiary
	GameData.set_data("cave_slime_discovered", true)
	
	# Ablities
	GameData.set_data("abilitie_dash", true)
	GameData.set_data("abilitie_wall_jump", true)
