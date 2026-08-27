extends Node

@export var enemies: Array[Item] = []

# Met à jour l'affichage des enemies
func refresh_enemies(slots: Array[Slot]) -> void:
	for slot in slots:
		slot.remove_objet()
	
	for item in enemies:
		if item.category != Item.CATEGORY_BESTIARY:
			continue
		
		var slot: Slot = slots[item.journal_slot - 1]
		if GameData.has_discovered_enemy(item):
			slot.set_object(item, item.icon, 0)
		else:
			slot.set_object(item, item.silhouette, 0)
