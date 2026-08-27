extends Node

@export var abilities: Array[Ability] = []

const ABILITIE_SCENE: PackedScene = preload("res://game/ui/journal/Components/Abilitie.tscn")

var abilities_nodes: Dictionary[String, Node] = {}

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
		if child is Ability_UI:
			child.queue_free()
	abilities_nodes.clear()
	
	# Ajoute les capacités apprises
	for ability: Ability in abilities:
		if GameData.has_ability(ability):
			var ability_ui: Ability_UI = ABILITIE_SCENE.instantiate()
			abilities_container.add_child(ability_ui)
			ability_ui.set_object(ability)
			
			abilities_nodes[ability.id] = ability_ui
