extends BoarState

func enter() -> void: 
	boar.animations.play("attack")
	boar.is_moving = false

func exit() -> void: 
	boar.animations.play("RESET")
	boar.animations.advance(0)

func update(_delta: float) -> void: 
	if boar.direction_to_player.x < 0:
		boar.body_sprite.flip_h = true
		boar.x_direction = -1
		
	else: 
		boar.body_sprite.flip_h = false
		boar.x_direction = 1
	
	boar.hitbox_component.position.x = boar.HITBOX_OFFSET * boar.x_direction
	
	if boar.distance_to_player > boar.run_distance:
		transition.emit(self, "idle")
	
	if !boar.attack_left.is_colliding() && !boar.attack_right.is_colliding():
		transition.emit(self, "run")

func physics_update(_delta: float) -> void:
	boar.velocity.x = lerp(boar.velocity.x, 0.0, boar.x_velocity_weight)
