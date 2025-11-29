extends TatakaState

func enter() -> void:
	tataka.reset_animation()
	tataka.animations.play("stomp")
	tataka.is_moving = false

func _physics_process(_delta: float) -> void:
	tataka.velocity.x = lerp(tataka.velocity.x, 0.0, tataka.x_velocity_weight)
