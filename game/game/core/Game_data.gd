class_name Game_data
extends Node

var data: Dictionary = {}

# Permet d'enregistrer une donnée
func set_data(key: String, value: Variant) -> void:
	data[key] = value

# Permet de récupérer une données enregistrée
func get_data(key: String, default_value: Variant = null) -> Variant:
	return data.get(key, default_value)

func show_all() -> void:
	print("--- GameData ---")
	print(data)
	print("-----")
