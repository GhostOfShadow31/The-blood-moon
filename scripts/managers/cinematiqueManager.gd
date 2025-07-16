extends Node

## Signaux
signal cinematic_finished

## Statut pour bloquer certaiones actions en jeu
var is_cinematic_on = false

var owner_of_cinematic = ""

## Lance la cinématique
func play_cinematic(cinematic_data: Dictionary) -> void:
	if is_cinematic_on:
		push_warning("Une cinématique est déjà en cours !")
		return
	
	# Délai avant chaque cinématique
	await get_tree().create_timer(cinematic_data["wait_before"]).timeout
	
	is_cinematic_on = true
	owner_of_cinematic = cinematic_data["owner"]
	_run_actions(cinematic_data["actions"])

# Lance une action
func _run_actions(actions: Array) -> void:
	_call_next_action(actions, 0)

# Lance la prochaine action
func _call_next_action(actions: Array, index: int) -> void:
	if index >= actions.size(): # La cinématique est finie
		is_cinematic_on = false
		emit_signal("cinematic_finished", owner_of_cinematic)
		return
	
	var action = actions[index]
	var actor_node = get_node_or_null(action["actor"])
	# On n'arrive pas à trouver l'acteur de la cinématique
	if not actor_node:
		push_error("Impossible de trouver l'acteur : ", action["actor"])
		_call_next_action(actions, index + 1)
		return
	
	var method_name = action["method"]
	var params = action.get("params", {})
	# On n'arrive pas à trouver la méthode à appeler
	if not actor_node.has_method(method_name):
		push_error("L'acteur n'a pas la méthode : ", method_name)
		_call_next_action(actions, index + 1)
		return
	
	# On suppose que chaque méthode d'acteur retourne un signal quand elle est finie
	actor_node.call(method_name, params)
	await actor_node.action_done
	
	# Ensuite on enchaîne
	_call_next_action(actions, index + 1)
