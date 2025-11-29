extends TatakaState

func enter() -> void:
	tataka.reset_animation()
	tataka.animations.play("stomp")
	tataka.animations.animation_finished.connect(_on_stomp_end)
	tataka.is_moving = false

func exit() -> void: 
	tataka.animations.animation_finished.disconnect(_on_stomp_end)

func physics_update(_delta: float) -> void:
	tataka.velocity.x = lerp(tataka.velocity.x, 0.0, tataka.x_velocity_weight)

func _on_stomp_end(animation_name: String) -> void: 
	if animation_name != "stomp":
		return
	
	if tataka.stomp_ray_left.is_colliding() || tataka.stomp_ray_right.is_colliding():
		tataka.animations.play("stomp")
		return 
	
	transition.emit(self, "throw")
