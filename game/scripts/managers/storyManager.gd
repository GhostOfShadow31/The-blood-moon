extends Node

## Signaux
signal step_finished # Fin d'un dialogue (step dans la story)

## Variables de base
var steps = [] # Liste d'étape à exécuter
var current_step_index = 0

# Si un step est déjà en cours
var is_playing = false

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_step_finished)
	await DialogueUi.ui_ready

# Joue une story
func play_story(new_steps: Array, index: int):
	if is_playing:
		print("play_story déjà en cours")
		return
	is_playing = true
	steps = new_steps
	current_step_index = index
	_play_current_step()

# Joue le step courant de la story
func _play_current_step():
	
	var step = steps[current_step_index]
	# Trois type de step pour l'instant
	match step.type:
		"dialogue":
			DialogueManager.load_dialogue(step.path, step.index, step.owner)
			
			if not DialogueManager.dialogue_ended.is_connected(_on_step_finished):
				# Quand DialogueManager finit, il émet un signal
				DialogueManager.dialogue_ended.connect(_on_step_finished, CONNECT_ONE_SHOT)
		"monologue":
			# Si c'est un monologue interne du joueur
			DialogueManager.load_dialogue(step.path, step.index, step.owner)
			
			if not DialogueManager.dialogue_ended.is_connected(_on_step_finished):
				DialogueManager.dialogue_ended.connect(_on_step_finished, CONNECT_ONE_SHOT)
		"cinematics":
			# Exemple : lancer une animation ou autre
			CinematiqueManager.play_cinematic(step)
			
			if not CinematiqueManager.cinematic_finished.is_connected(_on_step_finished):
				CinematiqueManager.cinematic_finished.connect(_on_step_finished)
		_:
			push_error("Type d'étape inconnu : %s" % step.type)

# Quand la story n'est plus en cours
func _on_step_finished(own):
	is_playing = false
	emit_signal("step_finished", own)
