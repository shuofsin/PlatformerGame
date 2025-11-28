extends BoarState

func enter() -> void: 
	boar.is_moving = false
	boar.time_to_idle = Global.rng.randf_range(3, 5)
	boar.idle_timer = boar.time_to_idle
	boar.animations.play("idle")
	pass

func update(delta: float) -> void:
	if boar.idle_timer >= 0: 
		boar.idle_timer -= delta
	else: 
		transition.emit(self, "roam")
	
	boar._check_for_player_run()
	boar._check_for_player_attack()

func physics_update(_delta: float) -> void:
	boar.velocity.x = lerp(boar.velocity.x, 0.0, boar.x_velocity_weight)
