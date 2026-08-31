extends CanvasLayer

@onready var journal: Control = $Journal
@onready var feedback: Control = $Feedback
@onready var map: Control = $Map

var is_journal_visible: bool = false
var is_map_visible: bool = false

# Initialise la map avec le joueur et le niveau dans lequel il est présent
func initialize(p: Player, l: Level) -> void:
	map.initialize(p, l)

# Détermine si le journal doit être affiché ou non
func toggle_journal() -> void:
	is_journal_visible = not is_journal_visible
	journal.set_active(is_journal_visible)

# Détermine si la carte doit être affichée ou non
func toggle_map() -> void:
	is_map_visible = not is_map_visible
	map.set_active(is_map_visible)

# Consomme unn objet consommable et renvoie un tableau des effets
func consume(item: Item) -> Array[ItemEffect]:
	return journal.consume(item)

# Affiche un feedback lors de la récupération d'un objet
func get_feedback(items: Dictionary) -> void:
	feedback.show_loot(items)

# Découvrir une salle sur la carte
func discover_room(room_id: int) -> void:
	map.discover_room(room_id)
