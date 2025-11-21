extends Node2D
class_name AbilityTexture

@export var animations: AnimationPlayer 
@export var sprite: Sprite2D

func play_animation(animation_name: String) -> void: 
	if !animations || !animations.get_animation(animation_name):
		return
	animations.play(animation_name)

func get_offset() -> float: 
	return sprite.texture.get_width()
