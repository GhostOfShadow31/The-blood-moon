extends Node

@export var abilities: Array[Abilitie] = []

const ABILITIE_SCENE: PackedScene = preload("res://game/ui/journal/Components/Abilitie.tscn")

var abilities_nodes: Dictionary[String, Node] = {}

# Savoir si une capacité est apprise
func is_abilitie_learned(abilitie: Abilitie) -> bool:
	return GameData.has_data("abilitie_" + abilitie.id)

# Retourne les noeuds seléctionnables
func get_selectable_nodes() -> Dictionary[String, Node]:
	var selectable: Dictionary[String, Node] = {}
	
	for abilitie_id in abilities_nodes:
		selectable["abilitie_" + abilitie_id] = abilities_nodes[abilitie_id]
	
	return selectable

# Met à jour l'affichage des capacités
func refresh_abilities(abilities_container: Control) -> void:
	# Supprimer anciennes capacités affichées
	for child in abilities_container.get_children():
		if child is Abilitie_UI:
			child.queue_free()
	abilities_nodes.clear()
	
	# Ajoute les capacités apprises
	for abilitie: Abilitie in abilities:
		if is_abilitie_learned(abilitie):
			var abilitie_ui: Abilitie_UI = ABILITIE_SCENE.instantiate()
			abilities_container.add_child(abilitie_ui)
			abilitie_ui.set_object(abilitie)
			
			abilities_nodes[abilitie.id] = abilitie_ui
