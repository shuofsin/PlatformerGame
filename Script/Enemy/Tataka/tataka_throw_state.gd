extends TatakaState

func enter() -> void: 
	tataka.rocks_thrown = 0
	tataka.reset_animation()
	tataka.animations.play("throw")
	tataka.animations.animation_finished.connect(_throw_rock)

func _process(_delta: float) -> void: 
	if (tataka.rocks_thrown == tataka.MAX_ROCK_THROWS):
		transition.emit(self, "jump")

func _throw_rock(animation_name: String) -> void: 
	if animation_name == "throw":
		tataka.throw_rock()
		tataka.animations.play("throw")
		tataka.rocks_thrown += 1
