extends PlayerState
class_name PlayerJumpState

func enter() -> void:
	player.animations.play(&"jump")

func physics_update(delta: float) -> void: 
	player.velocity.x = lerp(player.velocity.x, player.x_input * player.MAX_SPEED, player.x_velocity_weight)
	player.velocity.y = player.JUMP_HEIGHT
	player.jump_buffer_timer.stop()
	player.coyote_timer.stop()
	player.coyote_time_activated = true
	transition.emit(self, "air")
	player.run_gravity(delta)
