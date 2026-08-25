class_name ItemEffect
extends Resource

enum Type {
	HEALTH, # Modification immédiate d'une valeur
	RESOURCE, # Création d'une ressource
	BUFF, # Modification temporaire
	REVELATION # Modification persistante de l'état du monde
}

@export var type: Type

@export var amount: int = 0
@export var duration: float = 0.0
@export var target_id: String = ""
