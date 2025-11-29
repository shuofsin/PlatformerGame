extends Node2D
class_name AbilityTexture

@export var animations: AnimationPlayer 
@export var sprite: Sprite2D

func play_animation(animation_name: String) -> void: 
	if !animations || !animations.get_animation(animation_name):
		return
	animations.play(animation_name)

func get_offset() -> float: 
	return sprite.texture.get_width() / float(sprite.hframes)

func flip_animation_on_rotate(new_rotation: float):
	if new_rotation > (PI/2) || new_rotation < (-PI/2):
		sprite.flip_v = true
	else:
		sprite.flip_v = false

func connect_animation_finished(function: Callable):
	if !animations:
		return
	
	animations.animation_finished.connect(function)

func reset_animation() -> void: 
	if animations.has_animation("RESET"):
		animations.play("RESET")
		animations.advance(0)
