extends BoarState

func enter() -> void: 
	boar.animations.play("attack_hold")
	boar.animations.animation_finished.connect(_charge_player)
	boar.is_moving = false
	if boar.direction_to_player.x < 0:
		boar.body_sprite.flip_h = true
		boar.x_direction = -1
	else: 
		boar.body_sprite.flip_h = false
		boar.x_direction = 1

func update(delta: float) -> void:
	for i in range(boar.attack_rays.size()):
		if !boar.attack_rays[i].is_colliding():
			continue
		if i % 2 == 0 && boar.x_direction == -1:
			transition.emit(self, "attack")
			continue
		if i % 2 == 1 && boar.x_direction == 1:
			transition.emit(self, "attack")
	
	if !boar.is_moving: 
		return 
	
	boar.run_timer -= delta
	if boar.run_timer <= 0:
		transition.emit(self, "attack")

func physics_update(_delta: float) -> void:
	if boar.x_direction == -1 && !boar.ledge_left.is_colliding():
		return
	if boar.x_direction == 1 && !boar.ledge_right.is_colliding():
		return
	
	if boar.is_moving: 
		boar.velocity.x = lerp(boar.velocity.x, boar.x_direction * boar.MAX_SPEED_RUN, boar.x_velocity_weight)
	else: 
		boar.velocity.x = lerp(boar.velocity.x, 0.0, boar.x_velocity_weight)

func _charge_player(_animation_name: String) -> void: 
	boar.animations.play("run")
	boar.is_moving = true
	boar.run_timer = boar.TIME_TO_RUN
	boar.animations.animation_finished.disconnect(_charge_player)
