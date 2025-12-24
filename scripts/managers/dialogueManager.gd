extends Node

## Signaux pour prévenir l'UI
signal dialogue_changed(character, text, choices)
signal dialogue_ended(who: String)

var dialogues = []
var current_index = 0
var current_text = ""
var current_owner = ""

var is_dialogue_active = false

var expecting_choice: bool

# Permet de faire un dialogue
func load_dialogue(path: String, index: int, own: String):
	# Va chercher le dialogue
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	dialogues = JSON.parse_string(content)
	current_index = index
	current_owner = own
	is_dialogue_active = true
	_update_current_text()
	emit_current()

# Emet le dialogue courant
func emit_current():
	expecting_choice = not dialogues[current_index].choices.is_empty()
	
	if dialogues.is_empty():
		return
	
	var current = dialogues[current_index]
	emit_signal("dialogue_changed", current.character, current.text, current.choices)

# Passe au dialogue suivant
func next(response_idx = null):
	if dialogues.is_empty() or not is_dialogue_active:
		return
	
	var current = dialogues[current_index]
	
	if current.end:
		emit_signal("dialogue_ended", current_owner)
		is_dialogue_active = false
		return
	elif response_idx != null and current.choices.size() > 0 and "choices" in current.responses:
		current_index = current.responses["choices"][response_idx]
	elif "following" in current.responses:
		current_index = current.responses["following"]
	
	_update_current_text()
	expecting_choice = not dialogues[current_index].choices.is_empty()
	emit_current()

# Renvoie le texte de tout le dialogue
func get_current_text() -> String:
	return current_text

# Met à jour le texte de tout le dialogue
func _update_current_text():
	if dialogues.is_empty():
		current_text = ""
		return
	
	current_text = dialogues[current_index].text
