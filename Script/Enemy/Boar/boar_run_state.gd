extends BoarState

func enter() -> void: 
	boar.animations.play("run")
	boar.is_moving = true

func update(_delta: float) -> void:
	if boar.direction_to_player.x < 0:
		boar.body_sprite.flip_h = true
		boar.x_direction = -1
	else: 
		boar.body_sprite.flip_h = false
		boar.x_direction = 1
	
	if boar.distance_to_player > boar.run_distance:
		transition.emit(self, "idle")
		
	boar._check_for_player_attack()

func physics_update(_delta: float) -> void:
	boar.velocity.x = lerp(boar.velocity.x, boar.x_direction * boar.MAX_SPEED_RUN, boar.x_velocity_weight)
