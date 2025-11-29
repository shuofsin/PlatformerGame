extends TatakaState

func enter() -> void: 
	tataka.reset_animation()
	tataka.animations.play("throw")
	tataka.animations.animation_finished.connect(_throw_rock)

func _throw_rock(animation_name: String) -> void: 
	if animation_name == "throw":
		tataka.throw_rock()
		tataka.animations.play("throw")
