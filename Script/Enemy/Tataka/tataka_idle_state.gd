extends TatakaState

func enter() -> void: 
	tataka.reset_animation()
	tataka.animations.play("idle")
