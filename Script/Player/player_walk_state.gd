extends PlayerState

func enter() -> void:
	if player.is_weapon_charging: 
		player.animations.play(&"walk")
		return 
	player.animations.play(&"run")

func update(_delta: float) -> void: 
	if player.x_input == 0: 
		transition.emit(self, "idle")
	if player.is_weapon_charging && player.animations.current_animation == "run":
		player.animations.play(&"walk")
		return
	if !player.is_weapon_charging && player.animations.current_animation == "walk":
		player.animations.play(&"run")

func physics_update(delta: float) -> void: 
	player.velocity.x = lerp(player.velocity.x, player.x_input * player.max_speed, player.x_velocity_weight)
	
	player.coyote_time_activated = false
	player.gravity = lerp(player.gravity, player.MIN_GRAVITY, player.MIN_GRAVITY * delta)
	
	player.run_gravity(delta)
