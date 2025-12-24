extends Node2D

@export var pnjs: Array[Node2D]
@export var zone: Area2D

# Etape de la quête
var step: int = 0
var step_max: int
var is_player_giving_blood: bool
var is_arene_visited: bool = false

func _ready() -> void:
	step_max = pnjs.size()
	
	# On s'assure que l'on possède les export
	if pnjs == []:
		push_warning("Aucun pnj renseigné pour la quête: ", name)
	if zone == null:
		push_warning("Aucune zone renseignée pour la quête: ", name)
	
	# On connect les signaux
	zone.body_entered.connect(_on_body_entered)

func advance_step() -> void:
	if not step == 1 or is_arene_visited:
		step += 1
	if step == 2:
		DialogueUi.choosen_respons.connect(_player_choice)
		pnjs[2].visible = true # On rend le pnj visible

func end() -> void:
	if step != step_max:
		push_warning("Ce n'est pas la fin de la quête, step en cours: ", step, " -- step_max: ", step_max)
	else:
		print("C'est finie")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and step == 1:
		print("Le joueur est entré dans l'arène")
		is_arene_visited = true

func _player_choice(choice: String) -> void:
	match choice:
		"Accepter":
			is_player_giving_blood = true
		"Refuser":
			is_player_giving_blood = false
		_:
			push_warning("Choix inconnu: ", choice)
	DialogueUi.choosen_respons.disconnect(_player_choice)
