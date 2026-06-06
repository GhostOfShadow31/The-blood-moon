extends NinePatchRect

@onready var texture_rect: TextureRect = $Item

var item_infos = ""

signal hovered(item_name, item_description) # dest: inventaire.gd
signal unhovered() # dest: inventaire.gd

func _ready() -> void:
	# On connecte les signaux
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
	# Ajout du groupe
	self.add_to_group("slots")
	
	# On va chercher les informations sur tous les items
	var file = FileAccess.open("res://data/itemInfos/itemInfos.json", FileAccess.READ)
	var content = file.get_as_text()
	item_infos = JSON.parse_string(content)

# Quand la souris survol le slot
func _on_mouse_entered():
	if texture_rect.texture != null:
		# Récupère le chemin complet
		var texture_path = texture_rect.texture.resource_path
		
		# Extrait le nom de fichier sans extension
		var file_name = texture_path.get_file().get_basename()
		
		# Récupèe les informations dans le JSON
		var desc = ""
		
		for item in item_infos:
			if item["name"] == file_name:
				desc = item["description"]
				break
		
		hovered.emit(file_name, desc)

# Quand la souris ne survol plus le slot
func _on_mouse_exited():
	unhovered.emit()
