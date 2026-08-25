class_name Slot
extends Control

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var icon: Sprite2D = $AnimatedSprite2D/ItemIcon
@onready var quantity_label: Label = $AnimatedSprite2D/Quantity

var item: Item

func _ready() -> void:
	play("default")
	remove_objet()

# Joue l'animation donnée
func play(anim_name: String) -> void:
	sprite.play(anim_name)

# Met un objet dans le slot
func set_object(i: Item, texture: Texture, quantity: int) -> void:
	item = i
	icon.texture = texture
	
	var displayed_quantity: String = "x " + str(quantity) if quantity > 0 else ""
	quantity_label.text = displayed_quantity

# Récupère l'item d'un slot
func get_object() -> Item:
	return item

# Retir un objet du slot
func remove_objet() -> void:
	item = null
	icon.texture = null
	quantity_label.text = ""
