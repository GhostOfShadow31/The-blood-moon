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
@export var cons: Array[Item] = []
@export var coll: Array[Item] = []
@export var ques: Array[Quest] = []
@export var best: Array[Item] = []
@export var abil: Array[Ability] = []

func _ready() -> void:
	# Consommables
	#GameData.add_consumable(cons[0], 5)
	#GameData.add_consumable(cons[1], 2)
	
	# Collectibles
	GameData.add_collectible(coll[0])
	
	# Quests
	GameData.add_quest(ques[0], Quest.State.IN_PROGRESS)
	GameData.add_quest(ques[1], Quest.State.IN_PROGRESS)
	GameData.validate_quest_clue(ques[1], 0)
	GameData.validate_quest_clue(ques[1], 1)
	GameData.validate_quest_clue(ques[1], 2)
	GameData.set_quest_state(ques[1], Quest.State.COMPLETED)
	
	# Bestiary
	GameData.discover_enemy(best[0])
	
	# Ablities
	GameData.unlock_ability(abil[0])
	GameData.unlock_ability(abil[1])
