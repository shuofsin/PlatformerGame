extends TatakaState

func enter() -> void: 
	tataka.reset_animation()
	tataka.animations.play("idle")
	tataka.idle_timer = tataka.MAX_IDLE_TIME

func physics_update(delta: float) -> void:
	tataka.velocity.x = lerp(tataka.velocity.x, 0.0, tataka.x_velocity_weight)
	
	tataka.idle_timer -= delta 
	if tataka.idle_timer <= 0:
		transition.emit(self, "throw")
