extends PlayerState
class_name PlayerWalkState

func enter() -> void:
	player.animations.play(&"walk")

func update(_delta: float) -> void: 
	if player.x_input == 0: 
		transition.emit(self, "idle")
	pass

func physics_update(delta: float) -> void: 
	player.velocity.x = lerp(player.velocity.x, player.x_input * player.MAX_SPEED, player.x_velocity_weight)
	
	player.coyote_time_activated = false
	player.gravity = lerp(player.gravity, player.MIN_GRAVITY, player.MIN_GRAVITY * delta)
	
	player.run_gravity(delta)
