extends TatakaState

func enter() -> void:
	tataka.reset_animation()
	tataka.animations.play("jump")

func physics_update(_delta: float) -> void: 
	tataka.velocity.x = lerp(tataka.velocity.x, tataka.x_direction * tataka.MAX_SPEED_JUMP, tataka.x_velocity_weight)
	tataka.velocity.y = tataka.JUMP_HEIGHT
	transition.emit(self, "air")
