class_name SpawnContext
extends RefCounted

enum Type { FIRST_SPAWN, FROM_LEVEL }

var type: Type

# Indique le niveau du quel le joueur vient
var from_level: String = ""

# Indique l'endroit du niveau du quel le joueur vient
var from_spawn_id: String = ""
