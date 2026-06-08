extends Node
class_name Hero

@onready var character_body_2D: CharacterBody2D = $CharacterBody2D

### -- Signaux relatifs à l'état de santé du héro -- ###
signal hero_died
signal environment_damage

### -- Variables exportées -- ###
@export var invicibility_time: float = 1.0
@export var hp: int = 5

### -- Variables internes -- ###
var invincible: bool = false
var interactables: Array[Node] = []

var has_sword: bool = false

### -- Modifier l'état du héro -- ###
func is_moving() -> bool:
	return character_body_2D.get_move()

func stop_hero(anim_type: String) -> void:
	character_body_2D.set_can_move(false, anim_type)
	
func allow_hero() -> void:
	character_body_2D.set_can_move(true)

### -- Appliquer la physique -- ###
func _physics_process(delta: float) -> void:
	# Calcul du déplacement
	character_body_2D._hero_physics(delta)
	
	# On applique le déplacement au parent
	self.global_position += character_body_2D.get_motion_delta()
	
	# On remet le body à l'origine
	character_body_2D.position = Vector2.ZERO

### -- Modification des points de vie du héro -- ###
func take_damage(amount: int, from_environment: bool = false) -> void:
	if invincible or hp <= 0:
		return
	
	hp -= amount
	hp = max(hp, 0) # Pas de point de vie négatif
	
	hit_stop(0.1)
	character_body_2D.apply_knockback(self.global_position)
	
	if hp == 0:
		_die()
	else:
		_start_invincibility()
		if from_environment:
			emit_signal("environment_damage")

func revive() -> void:
	hp = 5

### -- Mort du hero -- ###
func _die() -> void:
	emit_signal("hero_died")
	self.stop_hero("death")

### -- Invicibilité du hero -- ###
func _start_invincibility() -> void:
	invincible = true
	var tween = create_tween()
	for i in range(4):
		tween.tween_property(self, "modulate:a", 0.4, invicibility_time/8)
		tween.tween_property(self, "modulate:a", 1.0, invicibility_time/8)
	await get_tree().create_timer(invicibility_time).timeout
	invincible = false

### -- Quand pique touchée -- ###
func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		self.take_damage(1, true)

### -- Hit-stop pour un dégât -- ###
func hit_stop(duration: float = 0.05) -> void:
	if Engine.time_scale == 0.0:
		return # Evite les empilements
	
	Engine.time_scale = 0.0
	
	await get_tree().create_timer(duration, true, false, true).timeout
	
	Engine.time_scale = 1.0

### -- Gestion de l'interaction -- ###
func register_interactable(node: Node) -> void:
	if node not in interactables:
		interactables.append(node)

func unregister_interactable(node: Node) -> void:
	interactables.erase(node)

func get_current_interactable() -> Node:
	if interactables.is_empty():
		return null
	
	var best: Node = null
	var best_distance: float = INF
	
	for i: Node in interactables:
		var distance = self.global_position.distance_to(i.global_position)
		
		if distance < best_distance:
			best_distance = distance
			best = i
	return best

### -- Obetnir l'épée -- ###
func enable_sword(value: bool = true) -> void:
	has_sword = value

### -- Gérer les inputs (sauf déplacements) -- ###
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		var target: Node = get_current_interactable()
		if target:
			target.interact()
	if event.is_action_pressed("ui_attack") and has_sword:
		character_body_2D.start_attack()
