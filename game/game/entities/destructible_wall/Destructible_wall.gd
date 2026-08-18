extends Enemy

enum HitDirection {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

@export var hit_direction: HitDirection = HitDirection.LEFT
@export var max_health: int = 3
@export var anim_name: String = "idle_1"

var health: int
var knockback_multiplier: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play(anim_name)
	health = max_health

# Un ennemi peut prendre des dégâts
func take_damage(amount: int, source_position: Vector2) -> void:
	if not is_hit_from_correct_position(source_position):
		return
	
	health = max(health - amount, 0)
	
	if health <= 0:
		die()
		return

# Recevoir un knockback
func apply_knockback(source_position: Vector2, knockback_force: Vector2) -> void:
	var dir: int = sign(global_position.x - source_position.x)
	
	velocity.x = dir * knockback_force.x * knockback_multiplier
	velocity.y = -knockback_force.y * knockback_multiplier

# Savoir si l'entité est morte
func is_dead() -> bool:
	return health <= 0

func die():
	visible = false
	set_collision_layer_value(1, false)

func is_hit_from_correct_position(source_position: Vector2) -> bool:
	var offset: Vector2 = source_position - global_position
	
	match hit_direction:
		HitDirection.LEFT:
			return offset.x < 0
		HitDirection.RIGHT:
			return offset.x > 0
		HitDirection.UP:
			return offset.y < 0
		HitDirection.DOWN:
			return offset.y > 0
	
	return false
