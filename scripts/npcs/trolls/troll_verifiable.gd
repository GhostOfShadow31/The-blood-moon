extends Node2D

@export var quest: Node2D

signal start_new_dialogue(index: int)
signal start_new_cinematique(index: int)
signal action_done()

var player_in_range: bool = false

func _ready() -> void:
	# On connecte les signaux
	StoryManager.step_finished.connect(_on_cinematic_finished)
	
	if quest == null:
		push_warning("Le pnj ne possède pas de quête")
		set_process(false)
		return

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_accept") and not Inventaire.is_inventory_active:
		if StoryManager.is_playing:
			DialogueUi.advance_or_close()

func walk_to(params: Dictionary) -> void:
	# On définit le point d'arrivée
	var target_array = params.get("target_position", [global_position.x, global_position.y])
	var target_pos = Vector2(target_array[0], target_array[1])
	var speed: float = params.get("speed", 100.0)
	
	# On se déplace
	while global_position.distance_to(target_pos) > 2.0:
		var dir = (target_pos - global_position).normalized()
		global_position += dir * speed * get_process_delta_time()
		await get_tree().process_frame
	
	emit_signal("action_done")

func _on_cinematic_finished(own: String) -> void:
	if own == "Troll_Verifiable":
		StoryManager.step_finished.disconnect(_on_cinematic_finished)
		StoryManager.step_finished.connect(_on_dialogue_ended)
		player_in_range = true
		if quest.step == 3:
				if quest.is_player_giving_blood:
					emit_signal("start_new_dialogue", 22)
				else:
					emit_signal("start_new_dialogue", 23)
				quest.advance_step()
				quest.end()
		else:
			push_warning("Mauvais step: ", quest.step)

func _on_dialogue_ended(_own: String) -> void:
	StoryManager.step_finished.disconnect(_on_dialogue_ended)
	emit_signal("start_new_cinematique", 27)
	await get_tree().create_timer(3.2).timeout
	visible = false
