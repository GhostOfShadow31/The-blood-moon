extends Node

@export var collectibles: Array[Item] = []

# Met à jour l'affichage des collectibles
func refresh_collectibles(slots: Array[Slot]) -> void:
	for slot in slots:
		slot.remove_objet()
	
	for item in collectibles:
		if item.category != Item.CATEGORY_COLLECTIBLES:
			continue
		
		var slot: Slot = slots[item.journal_slot - 1]
		if GameData.has_collectible(item):
			slot.set_object(item, item.icon, 1)
		else:
			slot.set_object(item, item.silhouette, 0)
