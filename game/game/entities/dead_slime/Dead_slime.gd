extends Interactable

@onready var slime: AnimatedSprite2D = $Slime
@onready var indicator: AnimatedSprite2D = $Indicator
@onready var shine_effect: PointLight2D = $Shine_effect

var has_interacted: bool = false
var player: Player = null

func _ready() -> void:
	slime.play("idle_with_sword")
	show_indicator(false)

func interact() -> void:
	if has_interacted:
		return
	has_interacted = true
	slime.play("idle_without_sword")
	show_indicator(false)
	player.has_sword = true
	shine_effect.energy = 0.5
	
	GameData.set_data("sword_collected", true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player or has_interacted:
		return
	player = body
	player.interactable = self
	show_indicator()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is not Player:
		return
	if player != null and player.interactable == self:
		player.interactable = null
	player = null
	show_indicator(false)

func show_indicator(show: bool = true) -> void:
	if show:
		indicator.visible = true
		indicator.play("idle")
	else:
		indicator.visible = false
		indicator.stop()
