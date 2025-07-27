extends Node2D

@export var steps: Array[Node] = [] # PNJ liés à la quête

var step: int = 0
var max_step: int

func _ready() -> void:
	max_step = steps.size()

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

func repeat(index: int) -> void:
	if index >= 0 and index < steps.size():
		steps[index].quest("PontCasse", index)
