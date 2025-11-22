extends Node2D
class_name DashStrike

@export var dash_texture: AbilityTexture
@export var hitbox_component: HitboxComponent
@export var dash_time: float
@export var dash_amount: float

func _ready() -> void: 
	dash_texture.play_animation("inactive")
	dash_texture.animations.animation_finished.connect(func (_current_animation: String) : cancel_dash_strike())

func activate_dash_strike(new_rotation: float) -> void:
	dash_texture.play_animation("dash_strike")
	_set_rotation(new_rotation)

func cancel_dash_strike() -> void: 
	dash_texture.animations.play("inactive")

func _set_rotation(new_rotation: float) -> void: 
	rotation = new_rotation
	dash_texture.flip_animation_on_rotate(new_rotation)
