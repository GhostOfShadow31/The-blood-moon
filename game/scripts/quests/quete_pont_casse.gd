extends Node2D

@export var pnjs: Array[Node2D]
@export var pont: AnimatedSprite2D
@export var blackscreen: TextureRect

# Etape de la quête
var step: int = 0
var step_max: int
# Transition pour la fin de quête
var blackscreen_on: bool = false
var blackscreen_off: bool = false

func _ready() -> void:
	step_max = pnjs.size()
	
	# On s'assure que l'on possède les export
	if pnjs == []:
		push_warning("Aucun pnj renseigné pour la quête: ", name)
	if pont == null:
		push_warning("Aucun pont rensigné pour la quête: ", name)
	if blackscreen == null:
		push_warning("Aucune transition rensigné pour la quête: ", name)

func _process(delta: float) -> void:
	if blackscreen_on:
		if blackscreen.modulate.a < 1.0:
			blackscreen.modulate.a += delta
			if blackscreen.modulate.a > 1.0:
				blackscreen.modulate.a = 1.0
				pont.play("repared")
				blackscreen_on = false
				blackscreen_off = true
	if blackscreen_off:
		if blackscreen.modulate.a > 0.0:
			blackscreen.modulate.a -= delta
			if blackscreen.modulate.a < 0.0:
				blackscreen.modulate.a = 0.0
				blackscreen_off = false

func advance_step() -> void:
	step += 1

func end() -> void:
	if step != step_max:
		push_warning("Ce n'est pas la fin de la quête, step en cours: ", step, " -- step_max: ", step_max)
	else:
		blackscreen_on = true
