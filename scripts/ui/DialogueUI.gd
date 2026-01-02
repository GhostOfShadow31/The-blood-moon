extends Node
class_name DialogueUI

@onready var speaker_label: Label = $SpeakerLabel
@onready var text_label: RichTextLabel = $TextLabel
@onready var portrait: TextureRect = $Portrait
@onready var next_indicator: TextureRect = $NextIndicator

var dialogue_lines: Array = []
var current_index: int = 0
var is_typing: bool = false
var typing_speed: float = 0.05 # Secondes par lettre

var showing: bool = false
var hiding: bool = false

func _ready() -> void:
	self.modulate.a = 0.0

func _process(delta: float) -> void:
	if showing:
		if self.modulate.a < 1.0:
			self.modulate.a += delta
		else:
			showing = false
	if hiding:
		if self.modulate.a > 0.0:
			self.modulate.a -= delta
		else:
			hiding = false

func start_dialogue(lines: Array) -> void:
	show_dialogue()
	dialogue_lines = lines
	current_index = 0
	show_next_line()
	
func show_next_line() -> void:	
	if current_index >= dialogue_lines.size():
		hide_dialogue()
		return
	
	var line = dialogue_lines[current_index]
	speaker_label.text = line.get("speaker", "")
	portrait.texture = line.get("portrait", null)
	text_label.text = ""
	next_indicator.visible = false
	
	await type_text(line.get("text", ""))
	if line.get("auto", false):
		# On passe automatiquement au prochain dialogue
		await get_tree().create_timer(1.5).timeout
		
		if line.get("pause_after", false):
			hide_dialogue()
			await get_tree().create_timer(line["pause_after"]).timeout
			show_dialogue()
		
		current_index += 1
		show_next_line()
		return
	else:
		# Affiche l'indicateur pour que le joueur clique
		next_indicator.visible = true
	
	# Gestion du next
	if line.has("next"):
		current_index = line["next"]
	else:
		current_index += 1

func type_text(text: String) -> void:
	text_label.text = ""
	is_typing = true
	for character in text:
		text_label.text += character
		await get_tree().create_timer(typing_speed).timeout
	is_typing = false
	next_indicator.visible = true

func show_dialogue() -> void:
	showing = true

func hide_dialogue() -> void:
	hiding = true
