extends TatakaState

func enter() -> void: 
	tataka.reset_animation()
	tataka.is_moving = true
	if tataka.x_direction < 0: 
		for sprite in tataka.sprites: 
			sprite.flip_h = true
	else: 
		for sprite in tataka.sprites: 
			sprite.flip_h = false

func physics_update(_delta: float) -> void:
	tataka.velocity.x = lerp(tataka.velocity.x, tataka.x_direction * tataka.MAX_SPEED, tataka.x_velocity_weight)
	
	if tataka.x_direction == 1: 
		if tataka.right_walk_ray.is_colliding() || !tataka.right_ledge_ray.is_colliding():
			tataka.x_direction = -1
			for sprite in tataka.sprites: 
				sprite.flip_h = true
	
	if tataka.x_direction == -1:
		if tataka.left_walk_ray.is_colliding() || !tataka.left_ledge_ray.is_colliding():
			tataka.x_direction = 1
			for sprite in tataka.sprites: 
				sprite.flip_h = false
