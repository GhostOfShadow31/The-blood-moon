extends Control


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/chapitres/grotte.tscn")
	# Remplcer par une scène d'intro ici


func _on_settings_button_pressed() -> void:
	print("Paramètre non-implémenter")


func _on_quit_play_pressed() -> void:
	get_tree().quit()
