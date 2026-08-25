extends Node

var owned_consumables: Dictionary[Item, int] = {}

# Ajoute un item aux items possédés
# avec la quantité indiqué
func add_consumable(item: Item, quantity: int = 1) -> void:
	if owned_consumables.has(item):
		owned_consumables[item] += quantity
	else:
		owned_consumables[item] = quantity

# Met à jour l'affichage des slots
# avec des consomables possédés (owned_consumables)
func refresh_consumables(slots: Array[Slot]) -> void:
	for slot in slots:
		slot.remove_objet()
	
	var slot_index: int = 0
	
	for item in owned_consumables:
		var quantity: int = owned_consumables[item]
		
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
	if not owned_consumables.has(item):
		return []
	
	owned_consumables[item] -= 1
	
	if owned_consumables[item] <= 0:
		owned_consumables.erase(item)
	
	return item.effects
