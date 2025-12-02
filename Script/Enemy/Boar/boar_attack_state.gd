extends BoarState

func enter() -> void: 
	boar.animations.play("attack")
	boar.animations.animation_finished.connect(_attack_end)
	boar.is_moving = false
	boar.hitbox_component.position.x = boar.HITBOX_OFFSET * boar.x_direction


func exit() -> void: 
	boar.animations.play("RESET")
	boar.animations.advance(0)
	boar.animations.animation_finished.disconnect(_attack_end)

func physics_update(_delta: float) -> void:
	boar.velocity.x = lerp(boar.velocity.x, 0.0, boar.x_velocity_weight)

func _attack_end(_animation_name: String) -> void:
	if boar.distance_to_player > boar.run_distance:
		transition.emit(self, "idle")
	else:
		transition.emit(self, "run")
