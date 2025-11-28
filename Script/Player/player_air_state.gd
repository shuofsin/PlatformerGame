extends PlayerState

func update(_delta: float) -> void: 
	if (player.velocity.y <= 0):
		player.animations.play(&"jump")
	else:
		player.animations.play(&"fall")

func physics_update(delta: float) -> void: 
	if player.wall_jump_lock > 0.0:
		player.wall_jump_lock -= delta
		player.velocity.x += player.x_input * delta
	else:  
		player.velocity.x = lerp(player.velocity.x, player.x_input * player.max_speed, player.x_velocity_weight)
		
	if player.is_on_floor(): 
		transition.emit(self, "idle")
	
	if !player.is_on_floor() and player.is_on_wall() and player.velocity.x != 0:
		player.look_dir_x = sign(player.velocity.x)
		transition.emit(self, "wallslide")
	
	# Cut velocity for variable jump height 
	# Ceiling check to prevent sticking 
	if (Input.is_action_just_released("move_jump") or player.is_on_ceiling()) and player.velocity.y < 0:
		player.velocity.y *= 0.5

	player.run_gravity(delta)
