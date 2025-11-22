extends Sprite2D
class_name PlayerGhostEffect

const FADE_TIME: float = 0.75

func _ready() -> void: 
	ghosting()

func set_properties(new_position: Vector2, new_scale: Vector2, new_rotation: float) -> void: 
	position = new_position
	scale = new_scale
	rotation = new_rotation
	if rotation > (PI/2) || rotation < (-PI/2):
		flip_v = true

func ghosting() -> void: 
	var tween_fade = create_tween()
	tween_fade.tween_property(self, "self_modulate", Color(1, 1, 1, 0), FADE_TIME)
	await tween_fade.finished
	queue_free()
