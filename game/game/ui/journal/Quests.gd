extends Node

@export var quests: Array[Quest] = []

const QUEST_SCENE: PackedScene = preload("res://game/ui/journal/Components/Quest.tscn")

var quests_nodes: Dictionary[String, Node] = {}

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
		if GameData.has_quest(quest):
			var quest_ui: Quest_UI = QUEST_SCENE.instantiate()
			quests_container.add_child(quest_ui)
			quest_ui.set_object(quest)
			quest_ui.set_state(GameData.get_quest_state(quest))
			
			quests_nodes[quest.id] = quest_ui
