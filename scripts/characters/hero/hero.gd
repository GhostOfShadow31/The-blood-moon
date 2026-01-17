extends Node
class_name Hero

@onready var character_body_2D: CharacterBody2D = $CharacterBody2D

### -- Signaux relatifs à l'état de santé du héro -- ###
signal health_changed(current: int)
signal hero_died
signal environment_damage

@export var invicibility_time: float = 1.0
@export var hp: int = 5

var invincible: bool = false

### -- Modifier l'état du héro -- ###
func is_moving() -> bool:
	return character_body_2D.get_move()

func stop_hero(anim_name: String) -> void:
	character_body_2D.set_can_move(false, anim_name)
	
func allow_hero() -> void:
	character_body_2D.set_can_move(true, null)

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
	emit_signal("health_changed", hp)
	
	if hp == 0:
		_die()
	else:
		_start_invincibility()
		
		if from_environment:
			emit_signal("environment_damage")

func _die() -> void:
	emit_signal("hero_died")
	self.stop_hero("death")

func _start_invincibility() -> void:
	invincible = true
	
	var tween = create_tween()
	for i in range(4):
		tween.tween_property(self, "modulate:a", 0.4, invicibility_time/8)
		tween.tween_property(self, "modulate:a", 1.0, invicibility_time/8)
	invincible = false

### -- Quand pique touchée -- ###
func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		self.take_damage(1, true)
