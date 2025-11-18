extends BoarState
class_name BoarRoamState

func enter() -> void: 
	boar.body_sprite.flip_h = !boar.body_sprite.flip_h
	boar.x_direction = -1 if boar.body_sprite.flip_h else 1
	boar.animations.play("roam")
	boar.time_to_roam = Global.rng.randf_range(2, 3)
	boar.roam_timer = boar.time_to_roam

func update(delta: float) -> void: 
	if boar.roam_timer >= 0:
		boar.roam_timer -= delta
	else: 
		transition.emit(self, "idle")
	
	boar._check_for_player_run()
	boar._check_for_player_attack()

func physics_update(_delta: float) -> void:
	boar.velocity.x = lerp(boar.velocity.x, boar.x_direction * boar.MAX_SPEED_ROAM, boar.x_velocity_weight)
	
	if boar.x_direction == -1 && boar.roam_left.is_colliding(): 
		transition.emit(self, "idle")
	
	if boar.x_direction == 1 && boar.roam_right.is_colliding():
		transition.emit(self, "idle")
