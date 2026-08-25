extends ColorRect

func _ready() -> void:
	self.color.a = 0.0

func fade_in_out(duration_fade: float = 2.0, duraction_active: float = 1.0) -> void:
	self.color.a = 0.0
	self.visible = true
	
	var tween = create_tween()
	tween.tween_property(self, "color:a", 1.0, duration_fade)
	await tween.finished
	
	await  get_tree().create_timer(duraction_active).timeout
	
	tween = create_tween()
	tween.tween_property(self, "color:a", 0.0, duration_fade)
	await tween.finished
