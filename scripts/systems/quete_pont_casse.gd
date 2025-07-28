extends Node2D

@export var steps: Array[Node] = [] # PNJ liés à la quête
@export var pont: AnimatedSprite2D
@export var transition: TextureRect

var step: int = 0
var max_step: int
var is_fade_in = false
var is_fade_out = false
var fade_speed = 0.5

func _ready() -> void:
	max_step = steps.size()

func _process(delta: float) -> void:
	if is_fade_in:
		if transition.modulate.a < 1.0:
			transition.modulate.a += fade_speed * delta * 2
			if transition.modulate.a >= 1.0:
				transition.modulate.a = 1.0
				pont.play("repared")
				is_fade_in = false
				is_fade_out = true
	if is_fade_out:
		if transition.modulate.a > 0.0:
			transition.modulate.a -= fade_speed * delta
			if transition.modulate.a < 0.0:
				transition.modulate.a = 0.0
				is_fade_out = false
				transition.visible = false

func get_current_step() -> Node:
	if step < steps.size():
		return steps[step]
	return null

func get_indexes_of_pnj(pnj: Node) -> Array[int]:
	var result: Array[int] = []
	for i in steps.size():
		if steps[i] == pnj:
			result.append(i)
	return result

func advance() -> void:
	if step < steps.size():
		steps[step].quest("PontCasse", step)
		step += 1
		if step == max_step:
			is_fade_in = true

func repeat(index: int) -> void:
	if index >= 0 and index < steps.size():
		steps[index].quest("PontCasse", index)
