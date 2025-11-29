extends TatakaState

func enter() -> void: 
	tataka.reset_animation()

func update(_delta: float) -> void: 
	if (tataka.velocity.y <= 0):
		tataka.animations.play("jump")
	else:
		tataka.animations.play("fall")

func physics_update(_delta: float) -> void: 
	tataka.velocity.x = lerp(tataka.velocity.x, tataka.x_direction * tataka.MAX_SPEED_JUMP, tataka.x_velocity_weight)
		
	if tataka.is_on_floor(): 
		transition.emit(self, "stomp")
