extends Node

var current_node: String = "consumables"

# Retourne le prochain noeud accessible depuis le noeud actuel
# dans la direction demabdé. Ne modifie pas le noeud actuel
func get_next_node(direction: String) -> String:
	var next_node = navigation[current_node][direction]
	
	if next_node != null:
		return next_node
	
	return current_node

# Met à jour la première rangée de slot 
# pour qu'elle renvoie vers l'onglet actif
func update_slot_naivation(current_tab: String) -> void:
	var slots: Array[String] = [
		"slot_01",
		"slot_02",
		"slot_03"
	]
	
	for slot in slots:
		navigation[slot]["up"] = current_tab

func set_quests_navigation(quests_ids: Array[String]) -> void:
	for i in range(quests_ids.size()):
		
		var previous_node: String = "quests"
		if i > 0:
			previous_node = quests_ids[i - 1]
		
		var next_node = null
		if i < quests_ids.size() - 1:
			next_node = quests_ids[i + 1]
		
		navigation[quests_ids[i]] = {
			"up": previous_node,
			"down": next_node,
			"left": null,
			"right": null
		}
	
	if quests_ids.size() > 0:
		navigation["quests"]["down"] = quests_ids[0]

func set_abilities_navigation(abilities_ids: Array[String]) -> void:
	for i in range(abilities_ids.size()):
		
		var previous_node: String = "abilities"
		if i > 0:
			previous_node = abilities_ids[i - 1]
		
		var next_node = null
		if i < abilities_ids.size() - 1:
			next_node = abilities_ids[i + 1]
		
		navigation[abilities_ids[i]] = {
			"up": previous_node,
			"down": next_node,
			"left": null,
			"right": null
		}
	
	if abilities_ids.size() > 0:
		navigation["abilities"]["down"] = abilities_ids[0]

var navigation: Dictionary = {
	"validator_yes": {
		"up": null,
		"down": null,
		"left": null,
		"right": "validator_no"
	},
	"validator_no": {
		"up": null,
		"down": null,
		"left": "validator_yes",
		"right": null
	},
	"consumables": {
		"up": null,
		"down": "slot_01",
		"left": null,
		"right": "collectibles"
	},
	"collectibles": {
		"up": null,
		"down": "slot_01",
		"left": "consumables",
		"right": "quests"
	},
	"quests": {
		"up": null,
		"down": null,
		"left": "collectibles",
		"right": "bestiary"
	},
	"bestiary": {
		"up": null,
		"down": "slot_01",
		"left": "quests",
		"right": "abilities"
	},
	"abilities": {
		"up": null,
		"down": null,
		"left": "bestiary",
		"right": null
	},
	"slot_01": {
		"up": "consumables",
		"down": "slot_04",
		"left": null,
		"right": "slot_02",
	},
	"slot_02": {
		"up": "consumables",
		"down": "slot_05",
		"left": "slot_01",
		"right": "slot_03",
	},
	"slot_03": {
		"up": "consumables",
		"down": "slot_06",
		"left": "slot_02",
		"right": null,
	},
	"slot_04": {
		"up": "slot_01",
		"down": "slot_07",
		"left": null,
		"right": "slot_05",
	},
	"slot_05": {
		"up": "slot_02",
		"down": "slot_08",
		"left": "slot_04",
		"right": "slot_06",
	},
	"slot_06": {
		"up": "slot_03",
		"down": "slot_09",
		"left": "slot_05",
		"right": null,
	},
	"slot_07": {
		"up": "slot_04",
		"down": "slot_10",
		"left": null,
		"right": "slot_08",
	},
	"slot_08": {
		"up": "slot_05",
		"down": "slot_11",
		"left": "slot_07",
		"right": "slot_09",
	},
	"slot_09": {
		"up": "slot_06",
		"down": "slot_12",
		"left": "slot_08",
		"right": null,
	},
	"slot_10": {
		"up": "slot_07",
		"down": "slot_13",
		"left": null,
		"right": "slot_11",
	},
	"slot_11": {
		"up": "slot_08",
		"down": "slot_14",
		"left": "slot_10",
		"right": "slot_12",
	},
	"slot_12": {
		"up": "slot_09",
		"down": "slot_15",
		"left": "slot_11",
		"right": null,
	},
	"slot_13": {
		"up": "slot_10",
		"down": "slot_16",
		"left": null,
		"right": "slot_14",
	},
	"slot_14": {
		"up": "slot_11",
		"down": "slot_17",
		"left": "slot_13",
		"right": "slot_15",
	},
	"slot_15": {
		"up": "slot_12",
		"down": "slot_18",
		"left": "slot_14",
		"right": null,
	},
	"slot_16": {
		"up": "slot_13",
		"down": "slot_19",
		"left": null,
		"right": "slot_17",
	},
	"slot_17": {
		"up": "slot_14",
		"down": "slot_20",
		"left": "slot_16",
		"right": "slot_18",
	},
	"slot_18": {
		"up": "slot_15",
		"down": "slot_21",
		"left": "slot_17",
		"right": null,
	},
	"slot_19": {
		"up": "slot_16",
		"down": "slot_22",
		"left": null,
		"right": "slot_20",
	},
	"slot_20": {
		"up": "slot_17",
		"down": "slot_23",
		"left": "slot_19",
		"right": "slot_21",
	},
	"slot_21": {
		"up": "slot_18",
		"down": "slot_24",
		"left": "slot_20",
		"right": null,
	},
	"slot_22": {
		"up": "slot_19",
		"down": "slot_25",
		"left": null,
		"right": "slot_23",
	},
	"slot_23": {
		"up": "slot_20",
		"down": "slot_26",
		"left": "slot_22",
		"right": "slot_24",
	},
	"slot_24": {
		"up": "slot_21",
		"down": "slot_27",
		"left": "slot_23",
		"right": null,
	},
	"slot_25": {
		"up": "slot_22",
		"down": "slot_28",
		"left": null,
		"right": "slot_26",
	},
	"slot_26": {
		"up": "slot_23",
		"down": "slot_29",
		"left": "slot_25",
		"right": "slot_27",
	},
	"slot_27": {
		"up": "slot_24",
		"down": "slot_30",
		"left": "slot_26",
		"right": null,
	},
	"slot_28": {
		"up": "slot_25",
		"down": null,
		"left": null,
		"right": "slot_29",
	},
	"slot_29": {
		"up": "slot_26",
		"down": null,
		"left": "slot_28",
		"right": "slot_30",
	},
	"slot_30": {
		"up": "slot_27",
		"down": null,
		"left": "slot_29",
		"right": null,
	}
}
