extends PlayerState


func update(_delta: float) -> void: 
	player.animations.play(&"wall")
	if (player.look_dir_x == -1):
		player.body_sprite.offset.x = -1
		if player.head_sprite.flip_v:
			player.head_sprite.offset.x = 1
		else:
			player.head_sprite.offset.x = -1
	else: 
		player.body_sprite.offset.x = 0
		player.head_sprite.offset.x = 0

func exit() -> void: 
	player.body_sprite.offset.x = 0
	player.head_sprite.offset.x = 0

func physics_update(_delta: float) -> void: 
	player.wall_contact_coyote = player.WALL_CONTACT_COYOTE_TIME
	player.velocity.y = player.WALL_GRAVITY
	player.velocity.x = lerp(player.velocity.x, player.x_input * player.max_speed, player.x_velocity_weight)
	if !player.is_on_wall():
		transition.emit(self, "air")
