extends Control

const CHECKBOX_SCENE: PackedScene = preload("res://game/ui/journal/Components/Checkbox.tscn")

# Conteneurs
@onready var slot_display: Control = $SlotDisplay
@onready var row_display: Control = $RowDisplay

# Élément d'UI
@onready var slot: Slot = $SlotDisplay/Slot
@onready var name_label_slot: Label = $SlotDisplay/Name
@onready var description_label_slot: Label = $SlotDisplay/Description
@onready var lore_label_slot: Label = $SlotDisplay/Lore

@onready var name_label_row: Label = $RowDisplay/Name
@onready var description_label_row: Label = $RowDisplay/Description
@onready var vbox_row: VBoxContainer = $RowDisplay/Checkboxs
@onready var separator: TextureRect = $RowDisplay/Separator_02

var item: Item
var quest: Quest
var ability: Ability

# Afficher les détails d'un item
func display_item(i: Item) -> void:
	clear()
	slot_display.visible = true
	
	item = i
	
	if not can_be_displayed(item):
		slot.set_object(item, item.silhouette, 0)
		name_label_slot.text = "???"
		description_label_slot.text = "???"
		lore_label_slot.text = "???"
		return
	
	slot.set_object(item, item.icon, 0)
	name_label_slot.text = item.item_name
	description_label_slot.text = item.description
	lore_label_slot.text = item.lore

# Afficher les détails d'une quête
func display_quest(q: Quest) -> void:
	clear()
	row_display.visible = true
	
	quest = q
	
	name_label_row.text = quest.title
	description_label_row.text = quest.description
	separator.visible = true
	
	for child in vbox_row.get_children():
		if child is Checkbox:
			child.queue_free()
	
	var clues: Array[bool] = GameData.get_quest_clues(quest)
	
	for i in range(quest.clues.size()):
		var checkbox: Checkbox = CHECKBOX_SCENE.instantiate()
		vbox_row.add_child(checkbox)
		
		checkbox.set_text(quest.clues[i].text)
		checkbox.set_state(clues[i])

# Afficher les détails d'une capacité
func display_abilitie(a: Ability):
	clear()
	row_display.visible = true
	
	ability = a
	
	name_label_row.text = ability.abilitiy_name
	description_label_row.text = ability.description
	separator.visible = false
	
	for child in vbox_row.get_children():
		if child is Checkbox:
			child.queue_free()

# Détermine si un item peut être affiché normalement
# Dans le Cas d'un collectible ou d'un monstre, s'il n'est pas découvert
func can_be_displayed(i: Item) -> bool:
	if not i.category == "collectibles" and not i.category == "bestiary":
		return true
	
	if i.category == "collectibles" and GameData.has_collectible(i):
		return true
	
	if i.category == "bestiary" and GameData.has_discovered_enemy(i):
		return true
	
	return false

# Efface l'ancien contenu
func clear() -> void:
	item = null
	quest = null
	ability = null
	slot_display.visible = false
	row_display.visible = false
