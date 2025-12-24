extends Node2D

@export var quest: Node2D
@export var talk_zone: Area2D

signal start_new_dialogue(index: int) # Dest: storyManager.gd
signal start_new_cinematique(index: int) # Dest: storyManager.gd
signal action_done() # Dest: cinematiqueManager.gd

var player_in_range: bool = false
var is_cinematic_on: bool = false

func _ready() -> void:
	# Ce pnj n'est pas visible avant que le step 2 de la quête soit atteint
	visible = false
	
	# On connecte les signaux
	talk_zone.body_entered.connect(on_body_entered)
	talk_zone.body_exited.connect(on_body_exited)
	
	if quest == null:
		push_warning("Le pnj ne possède pas de quête")
		set_process(false)
		return
	if talk_zone == null:
		push_warning("Le pnj ne possède pas de zone")
		set_process(false)
		return

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("ui_accept") and not Inventaire.is_inventory_active:
		if StoryManager.is_playing:
			DialogueUi.advance_or_close()
	elif player_in_range and not Inventaire.is_inventory_active:
		if quest.step == 2:
			if not is_cinematic_on:
				StoryManager.step_finished.connect(_on_first_cinematic_finished)
				emit_signal("start_new_cinematique", 24)
				is_cinematic_on = true

# Action à faire quand un joueur rentre dans la TalkZone
func on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Le joueur peut parler
		player_in_range = true

# Action à faire quand un joueur quitte la TalkZone
func on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		# Le joueur ne peut plus parler
		player_in_range = false

func _on_first_cinematic_finished(_own: String) -> void:
	StoryManager.step_finished.disconnect(_on_first_cinematic_finished)
	StoryManager.step_finished.connect(_on_dialogue_finished)
	
	emit_signal("start_new_dialogue", 21)
	quest.advance_step()

func _on_dialogue_finished(_own: String) -> void:
	StoryManager.step_finished.disconnect(_on_dialogue_finished)
	StoryManager.step_finished.connect(_on_second_cinematc_finished)
	
	if quest.is_player_giving_blood:
		emit_signal("start_new_cinematique", 25)
		await get_tree().create_timer(3.2).timeout
		visible = false
		talk_zone.get_child(0).disabled = true
	else:
		emit_signal("start_new_cinematique", 26)

func _on_second_cinematc_finished(_own: String) -> void:
	StoryManager.step_finished.disconnect(_on_second_cinematc_finished)
	if quest.is_player_giving_blood:
		emit_signal("start_new_cinematique", 26)
	else:
		await get_tree().create_timer(5).timeout
		emit_signal("start_new_cinematique", 27)

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
