extends PlayerState

func enter() -> void: 
	
	player.set_collision_mask_value(3, false)
	
	player.can_dash = false 
	player.is_dashing = true
	player.dash_timer = player.ability_manager.dash.dash_time
	
	player.dash_direction = player.global_position.direction_to(player.get_global_mouse_position()).normalized()
	player.velocity = player.dash_direction * player.ability_manager.dash.dash_amount
	
	player.set_weapon_active(false)
	player.ability_manager.weapon.visible = false
	
	player.animations.play(&"dash")
	player.sprites.rotation = player.dash_direction.angle()
	player.head_sprite.rotation = 0
	player.body_sprite.flip_h = false 
	if player.sprites.rotation > (PI/2) or player.sprites.rotation < (-PI/2):
		player.body_sprite.flip_v = true
		player.head_sprite.flip_v = true
	else: 
		player.body_sprite.flip_v = false
		player.head_sprite.flip_v = false
	
	player.ability_manager.dash.activate_dash_strike(player.body_sprite.global_rotation)
	player.time_between_ghosts = 0.05 - ((player.ability_manager.dash.dash_amount - 350) / 7000)
	player.ghost_timer = player.time_between_ghosts
	_add_ghost()

func exit() -> void: 
	player.animations.play(&"RESET")
	player.animations.advance(0)
	player.set_collision_mask_value(3, true)
	player.sprites.rotation = 0
	player.body_sprite.flip_v = false
	player.set_weapon_active(true)
	player.ability_manager.weapon.visible = true
	player.ghost_timer = 0
	player.is_dashing = false
	player.ability_manager.dash.cancel_dash_strike()

func update(delta: float) -> void: 
	if (player.ghost_timer >= 0):
		player.ghost_timer -= delta
	else: 
		player.ghost_timer = player.time_between_ghosts
		_add_ghost()

func physics_update(delta: float) -> void:
	player.dash_timer -= delta
	if player.dash_timer <= 0: 
		player.dash_timer = 0
		transition.emit(self, "air")
	
	if player.dash_timer > player.ability_manager.dash.dash_time - player.DASH_BUFFER: 
		return 
	
	if player.is_on_ceiling() || player.is_on_floor() || player.is_on_wall(): 
		transition.emit(self, "air")

func _add_ghost():
	if (player.ghost_sprite):
		var new_ghost = player.ghost_sprite.instantiate()
		new_ghost.set_properties(player.body_sprite.global_position, player.body_sprite.scale, player.body_sprite.global_rotation)
		get_tree().current_scene.add_child(new_ghost)
