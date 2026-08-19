class_name Collectible
extends Interactable

@export var unique_id: String
@export var display_name: String

# Fonction qui gère l'interaction
func interact() -> void:
	collect()

# Vérifie si un objet est récupérer, enregistre et déclenche la dispartition de l'objet
func collect() -> void:
	# TODO : enregistrer ke collectible avec unique_id
	queue_free()
