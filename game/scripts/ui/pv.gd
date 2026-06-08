extends Control

@onready var sprite: AnimatedSprite2D = $Health_points
@onready var anchor_point: TextureRect = $Visual_Anchor
@onready var low_hp_effect: PointLight2D = $low_hp_effect

var current_hp: int = 0
var speed_rotation: float = 0.05

### -- Lancement -- ###
func set_health(new_hp: int) -> void:
	var animation_name : String = "state_" + str(new_hp)
	sprite.play(animation_name)
	current_hp = new_hp
	if current_hp == 1:
		set_low_hp_effect_visible()

### -- Faire tourner le point d'ancrage visuel -- ###
func _process(delta: float) -> void:
	anchor_point.rotation += delta * speed_rotation

### -- Perdre un PV -- ###
func lose_one_hp() -> void:
	if current_hp <= 0:
		return
	
	var from : int = current_hp
	var to : int = current_hp - 1
	
	# Animation de perte
	sprite.play("break_%d_%d" % [from, to])
	current_hp = to
	
	# Retour à un état stable
	await sprite.animation_finished
	sprite.play("state_%d" % current_hp)

### -- Gagner un PV -- ###
func gain_one_hp() -> void:
	if current_hp >= 0:
		return
	
	var from : int = current_hp
	var to : int = current_hp + 1
	
	# Animation de perte
	sprite.play("restore_%d_%d" % [from, to])
	current_hp = to
	
	# Retour à un état stable
	await sprite.animation_finished
	sprite.play("state_%d" % current_hp)

### -- Afficher le low_hp_effect -- ###
func set_low_hp_effect_visible(value: bool = true) -> void:
	var tween = create_tween()
	if value:
		tween.tween_property(low_hp_effect, "energy", 1.5, 1.0)
	else:
		tween.tween_property(low_hp_effect, "energy", 0.0, 1.0)

### -- Changer de Pv -- ###
func change_health(new_hp: int) -> void:
	new_hp = clamp(new_hp, 0, 5) # On reste entre 0 et 5
	
	while current_hp < new_hp: # Regagner PVs
		await gain_one_hp()
	
	while current_hp > new_hp: # Perdre PVs
		await lose_one_hp()
	
	if current_hp == 1:
		set_low_hp_effect_visible()
	else:
		set_low_hp_effect_visible(false)
