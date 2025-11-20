extends Node2D
class_name DashStrike

@onready var animations: AnimationPlayer = %Animations
@onready var sprite: Sprite2D = %Sprite
var player: Player

func _ready() -> void:
	animations.play("inactive")
	animations.animation_finished.connect(func (current_animation: String) : cancel_dash_strike())

func activate_dash_strike(new_rotation: float) -> void:
	animations.play("dash_strike")
	_set_rotation(new_rotation)

func cancel_dash_strike() -> void: 
	if (animations.current_animation == "dash_strike"):
		animations.play("inactive")

func _set_rotation(new_rotation: float) -> void: 
	rotation = new_rotation
	if rotation > (PI/2) || rotation < (-PI/2):
		sprite.flip_v = true
	else:
		sprite.flip_v = false
