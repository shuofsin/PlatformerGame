extends BoarState

func enter() -> void: 
	boar.animations.play("attack")

func update(_delta: float) -> void: 
	boar.direction_to_player = boar.global_position.direction_to(boar.player.global_position)
	if boar.direction_to_player.x < 0:
		boar.body_sprite.flip_h = true
		boar.x_direction = -1
	else: 
		boar.body_sprite.flip_h = false
		boar.x_direction = 1
	
	boar.hit_box.position.x = 6.25 * boar.x_direction
	
	if boar.distance_to_player > boar.run_distance:
		transition.emit(self, "idle")
	
	if !boar.attack_left.is_colliding() && !boar.attack_right.is_colliding():
		transition.emit(self, "run")

func physics_update(_delta: float) -> void:
	boar.velocity.x = lerp(boar.velocity.x, 0.0, boar.x_velocity_weight)
