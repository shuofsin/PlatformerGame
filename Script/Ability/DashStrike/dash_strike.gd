extends Node2D
class_name DashStrike

@export var dash_texture: AbilityTexture
@export var hitbox_component: HitboxComponent
@export var dash_time: float
@export var dash_amount: float

func _ready() -> void: 
	if dash_texture:
		dash_texture.play_animation("inactive")
		dash_texture.connect_animation_finished(func (_current_animation: String) : cancel_dash_strike())
	_extra_ready()

func _process(delta: float) -> void:
	_extra_process(delta)

func _physics_process(delta: float) -> void:
	_extra_physics_process(delta)

func activate_dash_strike(new_rotation: float) -> void:
	dash_texture.play_animation("dash_strike")
	_set_rotation(new_rotation)

func cancel_dash_strike() -> void: 
	dash_texture.play_animation("inactive")

func _set_rotation(new_rotation: float) -> void: 
	rotation = new_rotation
	dash_texture.flip_animation_on_rotate(new_rotation)

func _extra_ready() -> void: 
	pass

func _extra_process(_delta: float) -> void: 
	pass

func _extra_physics_process(_delta: float) -> void: 
	pass
