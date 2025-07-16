extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var bubble_icon = $BubbleTalk
@onready var exclamation_point = $BubbleExclamation

signal start_new_dialogue(index: int) # Pour grotte.gd
signal start_new_cinematic(index: int) # Pour grotte.gd
signal action_done() # Pour CinematiqueManager

var player_in_range := false
var has_talked := false
var item := "res://assets/item/catalyseur.png" # Item donné au joueur

func _ready() -> void:
	sprite.play("idle")
	bubble_icon.visible = false
	exclamation_point.visible = false
	
	# On écoute la fin du dialogue
	StoryManager.step_finished.connect(_on_dialogue_ended)

func _process(_delta: float) -> void:
	# Clique pour skip les dialogues et monologues
	if Input.is_action_just_pressed("ui_accept"):
		if player_in_range and not StoryManager.is_playing:
			start_dialogue()
		elif StoryManager.is_playing:
			DialogueUi.advance_or_close()

# Première TalkZone
func _on_talk_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not has_talked:
		bubble_icon.visible = true
		bubble_icon.play("float")
		player_in_range = true

# Quand le joueur sors de la première TalkZone
func _on_talk_zone_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		bubble_icon.visible = false
		bubble_icon.stop()
		player_in_range = false

# Zone ou le pnj se déplace vers le bas (la ou le joueur est censé sortir) pour le rattraper et lui parler de force
func _on_talk_zone_2_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not has_talked:
		$"TalkZone 1/Dialogue".call_deferred("set_disabled", true)
		
		# On se déconnecte du signal pour le passer à la cinématique où le pnj rattrape le joueur
		StoryManager.step_finished.disconnect(_on_dialogue_ended)
		StoryManager.step_finished.connect(_on_chasing_ended)
		
		# Déplacement du pnj vers le joueur
		emit_signal("start_new_cinematic", 4)
		
		# Point d'exclamation
		exclamation_point.visible = true
		exclamation_point.play("idle")
		await exclamation_point.animation_finished
		await get_tree().create_timer(0.5).timeout
		exclamation_point.visible = false

# Quand le pnj a rattrapé le joueur
func _on_chasing_ended(who: String):
	if who != "Root":
		return
	
	# On se déconnecte du signal pour le passer au mdialogue
	StoryManager.step_finished.disconnect(_on_chasing_ended)
	StoryManager.step_finished.connect(_on_dialogue_ended)
	
	# Dialogue entre le héro et le pnj
	emit_signal("start_new_dialogue", 0)

# Permet de démarrer le dialogue du pnj
func start_dialogue():
	if not has_talked:
		# Désactive la bulle
		bubble_icon.visible = false
		bubble_icon.stop()
		
		emit_signal("start_new_dialogue", 0)
		has_talked = true

# Quand le dialogue se termine
func _on_dialogue_ended(who: String):
	if who != "ApotreElfe":
		# Ne concerne pas ce pnj
		return
	
	# On se déconnecte du signal pour le passer à la cinématique
	StoryManager.step_finished.disconnect(_on_dialogue_ended)
	StoryManager.step_finished.connect(_on_get_out_ended)
	
	Inventaire._add_item(item)
	
	# Le pnj sort de la caméra
	emit_signal("start_new_cinematic", 3)

# Cinématique de sortie du pnj
func _on_get_out_ended(who: String):
	if who != "Root":
		return
	
	# On se déconnecte du signal pour le passer au monologue
	StoryManager.step_finished.disconnect(_on_get_out_ended)
	StoryManager.step_finished.connect(_on_monologue_ended)
	
	# Monologue du héro
	emit_signal("start_new_dialogue", 1)

# Quand le monologue se termine
func _on_monologue_ended(who: String):
	if who != "Hero":
		# Le monologue est pour le héro
		return
	
	# On se déconnecte du signal
	StoryManager.step_finished.disconnect(_on_monologue_ended)

# Appelée pour les cinématiques où le pnj se déplace
func walk_to(params: Dictionary):
	sprite.stop()
	sprite.play("walk_down")
	
	# On définit le point d'arrivée
	var target_array = params.get("target_position", [global_position.x, global_position.y])
	var target_pos = Vector2(target_array[0], target_array[1])
	var speed: float = params.get("speed", 100.0)
	
	# On se déplace
	while global_position.distance_to(target_pos) > 2.0:
		var dir = (target_pos - global_position).normalized()
		global_position += dir * speed * get_process_delta_time()
		await get_tree().process_frame
	
	sprite.stop()
	sprite.play("idle")
	
	emit_signal("action_done") 
