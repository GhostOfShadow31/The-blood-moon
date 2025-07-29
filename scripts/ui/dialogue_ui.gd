extends CanvasLayer

@onready var text_label = $NinePatchRect/MarginContainer/HBoxContainer/DialogueRect/MarginContainer/VBoxContainer/DialogueLabel
@onready var portrait = $NinePatchRect/MarginContainer/HBoxContainer/PortraitRect/TextureRect

signal ui_ready # dest: storyManager.gd

var is_typing = false

func _ready():
	# On cache l'UI au début
	visible = false
	
	# On connecte les signaux
	DialogueManager.dialogue_changed.connect(_on_dialogue_changed)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	emit_signal("ui_ready")

# Quand un dialogue change (pas forcément la fin d'un dialogue)
func _on_dialogue_changed(character, text, _choices):
	visible = true
	
	match character:
		"Hero":
			portrait.texture = preload("res://assets/ui/dialogue/hero_portrait.png")
		"Apotre Elfe":
			portrait.texture = preload("res://assets/ui/dialogue/apotre_elfe_portrait.png")
		"Narrateur":
			portrait.texture = preload("res://assets/ui/dialogue/narrateur_portrait.png")
		_:
			portrait.texture = null
	
	text_label.text = ""
	is_typing = true
	await display_text_letter_by_letter(text)
	is_typing = false

# Permet d'afficher le message lettre par lettre
func display_text_letter_by_letter(text: String) -> void:
	for i in text.length():
		if not is_typing:
			break # On arrête la boucle si le joueur skip
		
		text_label.text += text[i]
		await get_tree().create_timer(0.03).timeout
	# On peut ajouter un son ici

# Permet au joueur de finir d'afficher le texte s'il est entrain d'être écrit
# Où bien de skip le dialogue si le texte est déjà là
func advance_or_close():
	if is_typing:
		# Si ça tape -> affiche tout direct
		is_typing = false
		text_label.text = DialogueManager.get_current_text()
	else:
		# Si tous est affiché, on passe au dialogue suivant
		DialogueManager.next()

# Permet de cacher le dialogue_ui
func _on_dialogue_ended(_own):
	hide()
