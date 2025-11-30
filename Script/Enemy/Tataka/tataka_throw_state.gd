extends TatakaState

func enter() -> void: 
	tataka.rocks_thrown = 0
	tataka.reset_animation()
	tataka.animations.play("throw")
	tataka.animations.animation_finished.connect(_throw_rock)

func update(_delta: float) -> void: 
	if (tataka.rocks_thrown == tataka.MAX_ROCK_THROWS):
		transition.emit(self, "jump")
	
	if tataka.stomp_ray_left.is_colliding() || tataka.stomp_ray_right.is_colliding():
		transition.emit(self, "stomp")
	
	if tataka.distance_to_player > tataka.throw_range: 
		transition.emit(self, "jump")

func physics_update(_delta: float) -> void:
	tataka.velocity.x = lerp(tataka.velocity.x, 0.0, tataka.x_velocity_weight)

func _throw_rock(animation_name: String) -> void: 
	if animation_name == "throw":
		tataka.animations.play("throw")
		tataka.rocks_thrown += 1
