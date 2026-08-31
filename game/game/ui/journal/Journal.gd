extends Control

const OFFSET: Vector2 = Vector2(0.0, 180.0)

# Onglets disponibles
enum ONGLETS {
	CONSUMABLES,
	COLLECTIBLES,
	QUESTS,
	BESTIARY,
	ABILITIES
}
var onglets: Dictionary[ONGLETS, String] = {
	ONGLETS.CONSUMABLES: "consumables",
	ONGLETS.COLLECTIBLES: "collectibles",
	ONGLETS.QUESTS: "quests",
	ONGLETS.BESTIARY: "bestiary",
	ONGLETS.ABILITIES: "abilities",
}

# Références vers des scripts
@onready var navigation: Node = $Navigation
@onready var consumables: Node = $Consumables
@onready var collectibles: Node = $Collectibles
@onready var quests: Node = $Quests
@onready var bestiary: Node = $Bestiary
@onready var abilities: Node = $Abilities

# Références vers des éléments d'UI
@onready var items_container: Control = $Content/Items
@onready var quests_container: Control = $Content/Quests
@onready var abilities_container: Control = $Content/Abilities

@onready var progress_bar: Progress_Bar = $ProgressBar
@onready var details: Control = $Content/Details
@onready var validator: Control = $Validator
@onready var selectable_nodes: Dictionary = {
	"validator_yes": $Validator/AnimatedSprite2D/Content/AnimatedSprite2D,
	"validator_no": $Validator/AnimatedSprite2D/Content/AnimatedSprite2D2,
	"consumables": $Tabs/Consumables,
	"collectibles": $Tabs/Collectibles,
	"quests": $Tabs/Quests,
	"bestiary": $Tabs/Bestiary,
	"abilities": $Tabs/Abilities
}

# Constantes
const VISIBLE_ROWS: int = 3
const SLOT_PER_ROW: int = 3
const TOTAL_SLOTS: int = 30

# Variables
var first_visible_row: int = 0
var current_tab: String = onglets[ONGLETS.CONSUMABLES]
var slots: Array[Slot] = []
var quests_slots: Array[Quest] = []
var is_journal_active: bool = false
var current_item: Item = null

func _ready() -> void:
	for child in items_container.get_children():
		if child is Slot:
			slots.append(child)

func _unhandled_input(event: InputEvent) -> void:
	if not is_journal_active:
		return
	
	var direction: String = ""
	
	if event.is_action_pressed("ui_up"):
		direction = "up"
	elif event.is_action_pressed("ui_down"):
		direction = "down"
	elif event.is_action_pressed("ui_left"):
		direction = "left"
	elif event.is_action_pressed("ui_right"):
		direction = "right"
	
	elif event.is_action_pressed("ui_accept"):
		var node = selectable_nodes[navigation.current_node]
		
		if navigation.current_node == "validator_yes" and current_item != null:
			print("Effets: ", consume(current_item))
			validator.hide_validator()
			select_node("consumables")
		elif navigation.current_node == "validator_no":
			validator.hide_validator()
			select_node("consumables")
		elif can_be_consumed(node):
			current_item = node.get_object()
			validator.show_validator()
			select_node("validator_yes")
	
	if direction != "":
		move_cursor(direction)

# Déplace le curseur vers le prochain noeud disponible
# et le sélectionne
func move_cursor(direction: String) -> void:
	var node_name: String = navigation.get_next_node(direction)
	select_node(node_name)
	update_scroll()

# Change le noeud actuellement seléctionné et met à jour
# son apparence ainsi que le contenu affiché
func select_node(node_name: String) -> void:
	selectable_nodes[navigation.current_node].play("default")
	navigation.current_node = node_name
	
	if onglets.values().has(node_name):
		current_tab = node_name
		navigation.update_slot_naivation(current_tab)
		update_content()
	
	selectable_nodes[navigation.current_node].play("selected")
	show_details()

# Met à jour le contenu visible du journal en fonction
# du noeud actuellement seléctionné
func update_content() -> void:
	var show_items: bool = false
	var key: int = onglets.find_key(current_tab)
	
	match key:
		ONGLETS.CONSUMABLES:
			show_items = true
			consumables.refresh_consumables(slots)
			set_selectable_content(get_selectable_items())
		ONGLETS.COLLECTIBLES:
			show_items = true
			collectibles.refresh_collectibles(slots)
			set_selectable_content(get_selectable_items())
		ONGLETS.QUESTS:
			show_items = false
			quests.refresh_quests(quests_container)
			var quests_nodes: Dictionary[String, Node] = quests.get_selectable_nodes()
			set_selectable_content(quests_nodes)
			navigation.set_quests_navigation(quests_nodes.keys())
		ONGLETS.BESTIARY:
			show_items = true
			bestiary.refresh_enemies(slots)
			set_selectable_content(get_selectable_items())
		ONGLETS.ABILITIES:
			show_items = false
			abilities.refresh_abilities(abilities_container)
			var abilities_nodes: Dictionary[String, Node] = abilities.get_selectable_nodes()
			set_selectable_content(abilities_nodes)
			navigation.set_abilities_navigation(abilities_nodes.keys())
	
	items_container.visible = show_items
	quests_container.visible = current_tab == onglets[ONGLETS.QUESTS]
	abilities_container.visible = current_tab == onglets[ONGLETS.ABILITIES]

# Met à jour les lignes de slot visibles
func update_visible_slots() -> void:
	for i in range(TOTAL_SLOTS):
		var row: int = floori(float(i) / SLOT_PER_ROW)
		var slot: Slot = slots[i]
		
		slot.visible = (
			row >= first_visible_row
			and row < first_visible_row + VISIBLE_ROWS
		)

# Met à jour la première ligne de slot affichée
# et la ScrollBar
func update_scroll() -> void:
	if not navigation.current_node.begins_with("slot_"):
		return
	
	var slot_index: int = int(navigation.current_node.trim_prefix("slot_")) - 1
	var current_row: int = floori(float(slot_index) / SLOT_PER_ROW)
	
	if current_row < first_visible_row:
		first_visible_row = current_row
		progress_bar.show_pos(first_visible_row)
	
	elif current_row >= first_visible_row + VISIBLE_ROWS:
		first_visible_row = current_row - VISIBLE_ROWS + 1
		progress_bar.show_pos(first_visible_row)
	
	update_visible_slots()

# Enregistre les noeud seléctionnable
# en fonction d'un onglet
func set_selectable_content(nodes: Dictionary) -> void:
	selectable_nodes = {
		"validator_yes": $Validator/AnimatedSprite2D/Content/AnimatedSprite2D,
		"validator_no": $Validator/AnimatedSprite2D/Content/AnimatedSprite2D2,
		"consumables": $Tabs/Consumables,
		"collectibles": $Tabs/Collectibles,
		"quests": $Tabs/Quests,
		"bestiary": $Tabs/Bestiary,
		"abilities": $Tabs/Abilities
	}
	selectable_nodes.merge(nodes, false)

# Obtenir tous les slots pour stocker les items
func get_selectable_items() -> Dictionary:
	var nodes: Dictionary = {}
	
	for i in range(1, TOTAL_SLOTS + 1):
		var slot: Slot = get_node("Content/Items/Slot_%02d" % i)
		nodes["slot_%02d" % i] = slot
	
	return nodes

# Ajoute un consommable dans le journal
func add_consumable(item: Item, quantity: int = 1) -> void:
	consumables.add_consumable(item, quantity)

# Affiche les détails d'un objet seléctionné
func show_details() -> void:
	if is_tab(navigation.current_node):
		details.visible = false
		return
		
	var node = selectable_nodes[navigation.current_node]
	
	if not is_displayable(node) or node is Slot and not is_displayable_item(node):
		details.visible = false
		return
	details.visible = true
	
	if node is Slot:
		details.display_item(node.get_object())
	elif node is Quest_UI:
		details.display_quest(node.get_object())
	elif node is Ability_UI:
		details.display_abilitie(node.get_object())

# Détermine si un noeud est un onglet
func is_tab(node) -> bool:
	if onglets.find_key(node) != null:
		return true
	return false

# Détermine si le noeud est du bon type pouyr afficher
func is_displayable(node) -> bool:
	if node is Slot or node is Quest_UI or node is Ability_UI:
		return true
	return false

# Détermine si un noeud possède des détails à afficher
func is_displayable_item(node) -> bool:
	if node.get_object() == null:
			return false
	return true

# Teste si un item peut être consommé
func can_be_consumed(node) -> bool:
	if node is Slot:
		var obj = node.get_object() 
		if obj is Item and obj != null and obj.category == onglets[ONGLETS.CONSUMABLES]:
			return true
	return false

# Consomme un objet consommable et renvoie un tableau des effets
func consume(item: Item) -> Array[ItemEffect]:
	if item.category != onglets[ONGLETS.CONSUMABLES]:
		return []
	
	var effects: Array[ItemEffect] = consumables.consume(item)
	consumables.refresh_consumables(slots)
	return effects

# Définit si le journal est actif ou non
func set_active(value: bool) -> void:
	is_journal_active = value
	if value:
		var tween := create_tween()
		tween.tween_property(self, "global_position", global_position - OFFSET, 0.15)
		
		select_node("consumables")
	else:
		var tween := create_tween()
		tween.tween_property(self, "global_position", global_position + OFFSET, 0.15)
		
		if validator.is_validator_active:
			validator.hide_validator()
