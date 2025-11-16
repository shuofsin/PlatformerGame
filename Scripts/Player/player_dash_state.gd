extends PlayerState
class_name PlayerDashState

func enter() -> void: 
	player.can_dash = false 
	player.is_dashing = true
	player.dash_timer = player.DASH_TIME
	
	player.dash_direction = player.global_position.direction_to(player.get_global_mouse_position()).normalized()
	player.velocity = player.dash_direction * player.DASH_AMOUNT
	
	player.weapon.reset()
	player.weapon.visible = false
	
	player.animations.play("dash")
	player.sprites.rotation = player.dash_direction.angle()
	player.head_sprite.rotation = 0
	player.body_sprite.flip_h = false 
	if player.sprites.rotation > (PI/2) or player.sprites.rotation < (-PI/2):
		player.body_sprite.flip_v = true
		player.head_sprite.flip_v = true
	else: 
		player.body_sprite.flip_v = false
		player.head_sprite.flip_v = false
	
	player.dash_strike.activate_dash_strike(player.body_sprite.global_rotation)
	player.ghost_timer = player.TIME_BETWEEN_GHOSTS
	_add_ghost()

func exit() -> void: 
	player.sprites.rotation = 0
	player.body_sprite.flip_v = false
	player.weapon.visible = true
	player.ghost_timer = 0
	player.is_dashing = false

func update(delta: float) -> void: 
	if (player.ghost_timer >= 0):
		player.ghost_timer -= delta
	else: 
		player.ghost_timer = player.TIME_BETWEEN_GHOSTS
		_add_ghost()

func physics_update(delta: float) -> void:
	player.dash_timer -= delta
	if player.dash_timer <= 0: 
		player.dash_timer = 0
		transition.emit(self, "air")

func _add_ghost():
	if (player.ghost_sprite):
		var new_ghost = player.ghost_sprite.instantiate()
		new_ghost.set_properties(player.body_sprite.global_position, player.body_sprite.scale, player.body_sprite.global_rotation)
		get_tree().current_scene.add_child(new_ghost)
