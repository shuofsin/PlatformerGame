extends TatakaState

func enter() -> void: 
	tataka.reset_animation()
	tataka.is_moving = true

func physics_update(_delta: float) -> void:
	tataka.velocity.x = lerp(tataka.velocity.x, tataka.x_direction * tataka.MAX_SPEED, tataka.x_velocity_weight)
	
	if tataka.x_direction == 1: 
		if tataka.right_walk_ray.is_colliding() || !tataka.right_ledge_ray.is_colliding():
			tataka.x_direction = -1
	
	if tataka.x_direction == -1:
		if tataka.left_walk_ray.is_colliding() || !tataka.left_ledge_ray.is_colliding():
			tataka.x_direction = 1
