extends Node

# Met à jour l'affichage des slots
func refresh_consumables(slots: Array[Slot]) -> void:
	for slot in slots:
		slot.remove_objet()
	
	var slot_index: int = 0
	
	var all_consumables: Dictionary = GameData.get_all_consumables()
	for item in all_consumables:
		var quantity: int = all_consumables[item]
		
		var full_stacks = floori(float(quantity) / item.max_stack)
		var remainder: int = quantity % item.max_stack
		
		for i in full_stacks:
			if slot_index >= slots.size():
				return
			slots[slot_index].set_object(item, item.icon, item.max_stack)
			slot_index += 1
		
		if remainder > 0:
			if slot_index >= slots.size():
				return
			slots[slot_index].set_object(item, item.icon, remainder)
			slot_index += 1

# Consommer un item et renvoie un tableau des effets
func consume(item: Item) -> Array[ItemEffect]:
	if not GameData.has_consumable(item):
		return []
	
	GameData.remove_consumable(item, 1)
	
	return item.effects
