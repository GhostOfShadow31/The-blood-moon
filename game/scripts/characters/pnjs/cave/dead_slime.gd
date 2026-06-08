extends Node2D

@onready var slime: AnimatedSprite2D = $Slime
@onready var indicator: AnimatedSprite2D = $Indicator
@onready var shine_effect: PointLight2D = $Shine_effect

var has_interacted: bool = false
var hero: Hero = null

func _ready() -> void:
	slime.play("idle_with_sword")
	indicator.visible = false

func interact() -> void:
	has_interacted = true
	slime.play("idle_without_sword")
	indicator.visible = false
	indicator.stop()
	var tween = create_tween()
	tween.tween_property(shine_effect, "energy", 0.5, 0.2)
	
	if hero:
		hero.enable_sword()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent() is Hero and not has_interacted:
		indicator.visible = true
		indicator.play("idle")
		hero = body.get_parent()
		hero.register_interactable(self)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.get_parent() is Hero:
		indicator.visible = false
		indicator.stop()
		body.get_parent().unregister_interactable(self)
		hero = null
