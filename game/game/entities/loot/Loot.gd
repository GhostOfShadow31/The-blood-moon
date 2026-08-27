extends Interactable

const SHINIEST: float = 0.05
const DARKEST: float = 0.0
const DURATION: float = 5.0

@onready var halo: PointLight2D = $Halo
@onready var gradient: Gradient = $Halo.texture.gradient
@onready var top_pivot: Node2D = $TopPivot
@onready var sprite_top: Sprite2D = $TopPivot/Top

var has_interacted: bool = false
var player: Player = null
var tween_loop = create_tween().set_loops()

@export var loot: Dictionary[Item, int] = {}

func _ready() -> void:
	tween_loop.tween_method(set_gradient_offset, DARKEST, SHINIEST, DURATION)
	tween_loop.tween_method(set_gradient_offset, SHINIEST, DARKEST, DURATION)

func set_gradient_offset(value: float) -> void:
	var offsets: PackedFloat32Array= gradient.offsets
	offsets[1] = value
	gradient.offsets = offsets

func set_gradient_color(value: Color) -> void:
	var colors: PackedColorArray= gradient.colors
	colors[1] = value
	gradient.colors = colors

func interact() -> void:
	if has_interacted:
		return
	has_interacted = true
	
	var tween = create_tween()
	tween.tween_property(sprite_top, "position", Vector2(0.0, -5.5), 1.5)
	tween.tween_interval(0.25)
	tween.tween_property(top_pivot, "rotation", deg_to_rad(-45.0), 0.75).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(halo, "energy", 0.0, 1.0)
	
	for item in loot:
		GameData.add_consumable(item, loot[item])

func _on_interact_zone_body_entered(body: Node2D) -> void:
	if body is not Player or has_interacted:
		return
	player = body
	player.interactable = self
