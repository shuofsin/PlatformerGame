extends PlayerState

func enter() -> void:
	player.animations.play(&"jump")

func physics_update(delta: float) -> void: 
	player.velocity.x = lerp(player.velocity.x, player.x_input * player.max_speed, player.x_velocity_weight)
	player.velocity.y = player.JUMP_HEIGHT
	player.jump_buffer_timer.stop()
	player.coyote_timer.stop()
	player.coyote_time_activated = true
	transition.emit(self, "air")
	player.run_gravity(delta)
