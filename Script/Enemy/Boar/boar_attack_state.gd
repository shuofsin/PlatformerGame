extends BoarState

func enter() -> void: 
	boar.animations.play("attack_hold")
	boar.animations.animation_finished.connect(_attack_end)
	boar.is_moving = false

func exit() -> void: 
	boar.animations.play("RESET")
	boar.animations.advance(0)
	boar.animations.animation_finished.disconnect(_attack_end)

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

func physics_update(delta: float) -> void:
	boar.velocity.x = lerp(boar.velocity.x, 0.0, boar.x_velocity_weight)
	boar.attack_timer -= delta
	if boar.attack_timer <= 0: 
		boar.attack_timer = boar.TOTAL_ATTACK_TIME
		boar.animations.play("attack")

func _attack_end(animation_name: String) -> void:
	if animation_name == "attack" || animation_name == "attack_hold":
		for ray in boar.attack_rays:
			if ray.is_colliding():
				return
		transition.emit(self, "run")
