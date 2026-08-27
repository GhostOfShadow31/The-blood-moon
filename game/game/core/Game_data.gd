class_name Game_data
extends Node

var data: Dictionary = {
	"world": {},
	"journal": {
		"consumables": {},
		"collectibles": {},
		"quests": {},
		"bestiary": {},
		"abilities": {}
	}
}

func show_all() -> void:
	print("--- GameData ---")
	print(data)
	print("-----")

# -- World --
func set_world_state(id: String, value: Variant) -> void:
	data["world"][id] = value

func get_state_world(id: String, default_value: Variant = null) -> Variant:
	return data["world"].get(id, default_value)

# -- Consommables --
func add_consumable(item: Item, quantity: int) -> void:
	var current_quantity: int = data["journal"]["consumables"].get(item, 0)
	data["journal"]["consumables"][item] = current_quantity + quantity

func remove_consumable(item: Item, quantity: int) -> void:
	var current_quantity: int = data["journal"]["consumables"].get(item, 0)
	current_quantity -= quantity
	
	if current_quantity <= 0:
		data["journal"]["consumables"].erase(item)
	else:
		data["journal"]["consumables"][item] = current_quantity

func get_consumable_quantity(item: Item, default_value: Variant = null) -> Variant:
	return data["journal"]["consumables"].get(item, default_value)

func get_all_consumables() -> Dictionary:
	return data["journal"]["consumables"]

func has_consumable(item: Item) -> bool:
	return data["journal"]["consumables"].has(item)

# -- Collectibles --
func add_collectible(item: Item) -> void:
	data["journal"]["collectibles"][item] = true

func has_collectible(item: Item) -> bool:
	return data["journal"]["collectibles"].has(item)

# -- Quests --
func add_quest(quest: Quest, state: Quest.State) -> void:
	var quest_data: Dictionary = {
		"state": state,
		"clues": quest.clues_bool
	}
	data["journal"]["quests"][quest] = quest_data

func set_quest_state(quest: Quest, state: Quest.State) -> void:
	var quest_data: Dictionary = data["journal"]["quests"].get(quest)
	if quest_data == null:
		return
	quest_data["state"] = state
	data["journal"]["quests"][quest] = quest_data

func get_quest_state(quest: Quest) -> Variant:
	var quest_data: Dictionary = data["journal"]["quests"].get(quest)
	if quest_data == null:
		return null
	return quest_data["state"]

func get_quest_clues(quest: Quest) -> Variant:
	var quest_data: Dictionary = data["journal"]["quests"].get(quest)
	if quest_data == null:
		return null
	return quest_data["clues"]

func validate_quest_clue(quest: Quest, clue_index: int) -> void:
	var quest_data: Dictionary = data["journal"]["quests"].get(quest)
	if quest_data == null:
		return
	var clues: Array[bool] = quest_data["clues"]
	if clue_index < 0 or clue_index >= clues.size():
		return
	clues[clue_index] = true

func has_quest(quest: Quest) -> bool:
	return data["journal"]["quests"].has(quest)

# -- Bestiaire --
func discover_enemy(item: Item) -> void:
	data["journal"]["bestiary"][item] = true

func has_discovered_enemy(item: Item) -> bool:
	return data["journal"]["bestiary"].has(item)

# -- Capacités --
func unlock_ability(ability: Ability) -> void:
	data["journal"]["abilities"][ability] = true

func has_ability(ability: Ability) -> bool:
	return data["journal"]["abilities"].has(ability)
