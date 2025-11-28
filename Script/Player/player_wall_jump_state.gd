extends PlayerState


func enter() -> void:
	player.animations.play(&"jump")

func physics_update(delta: float) -> void: 
	player.velocity.y = player.JUMP_HEIGHT
	if player.wall_contact_coyote > 0.0:
		player.velocity.x = -player.look_dir_x * player.WALL_JUMP_PUSH_FORCE
		player.wall_jump_lock = player.WALL_JUMP_LOCK_TIME
	transition.emit(self, "air")
	
	player.run_gravity(delta)
