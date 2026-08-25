extends Node

@export var quests: Array[Quest] = []

const QUEST_SCENE: PackedScene = preload("res://game/ui/journal/Components/Quest.tscn")

var quests_nodes: Dictionary[String, Node] = {}

# Savoir si une quête est enregistrée
func is_quest_registered(quest: Quest) -> bool:
	return GameData.has_data("quest_" + quest.id)

# Récupère l'état d'une quête
func get_quest_state(quest: Quest) -> Quest.State:
	var quest_data: Dictionary = GameData.get_data("quest_" + quest.id, {})
	return quest_data.get("state", Quest.State.IN_PROGRESS)

# Changer l'état d'une quête
func set_quest_state(quest: Quest, state: Quest.State) -> void:
	var quest_data: Dictionary = GameData.get_data("quest_" + quest.id, {})
	
	quest_data["state"] = state
	
	GameData.set_data("quest_" + quest.id, quest_data)

# Enregistrer une quête
func register_quest(quest: Quest) -> void:
	var clues: Array[bool] = []
	
	for clue in quest.clues:
		clues.append(false)
	
	var quest_data: Dictionary = {
		"state": Quest.State.IN_PROGRESS,
		"clues": clues
	}
	
	GameData.set_data("quest_" + quest.id, quest_data)

# Valider un indice de la quête
func validate_clue(quest: Quest, clue_index: int) -> void:
	var quest_data: Dictionary = GameData.get_data("quest_" + quest.id, {})
	
	var clues: Array[bool] = quest_data.get("clues", [])
	if clue_index < 0 or clue_index >= clues.size():
		return
		
	clues[clue_index] = true
	quest_data["clues"] = clues
	
	GameData.set_data("quest_" + quest.id, quest_data)

# Retourne les noeuds seléctionnables
func get_selectable_nodes() -> Dictionary[String, Node]:
	var selectable: Dictionary[String, Node] = {}
	
	for quest_id in quests_nodes:
		selectable["quest_" + quest_id] = quests_nodes[quest_id]
	
	return selectable

# Met à jour l'affichage des quêtes
func refresh_quests(quests_container: Control) -> void:
	# Supprimer anciennes quêtes affichées
	for child in quests_container.get_children():
		if child is Quest_UI:
			child.queue_free()
	quests_nodes.clear()
	
	# Ajoute les quêtes enregistrées
	for quest: Quest in quests:
		if is_quest_registered(quest):
			var quest_ui: Quest_UI = QUEST_SCENE.instantiate()
			quests_container.add_child(quest_ui)
			quest_ui.set_object(quest)
			quest_ui.set_state(get_quest_state(quest))
			
			quests_nodes[quest.id] = quest_ui
