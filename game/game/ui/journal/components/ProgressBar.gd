class_name Progress_Bar
extends Control

const NUMBER_POSITIONS: int = 8
const LENGTH_PROGRESS_BARR: float = 92.0
const OFFSET: Vector2 = Vector2(-45, 0)

@onready var telltale: Sprite2D = $Telltale
@onready var progressbar_ui: Sprite2D = $Background/Control/Progression

# Permet d'afficher une position compris dans [0-7]
func show_pos(index: int) -> void:
	if index < 0 or index >= NUMBER_POSITIONS:
		return
	
	var new_pos_x: int = floori(index * LENGTH_PROGRESS_BARR / (NUMBER_POSITIONS - 1))
	
	progressbar_ui.position.x = new_pos_x
	progressbar_ui.position += OFFSET
	
	telltale.position.x = new_pos_x
	telltale.position += OFFSET
