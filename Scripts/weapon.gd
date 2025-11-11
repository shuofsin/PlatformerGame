extends Node2D

@onready var arrow_scene: PackedScene = preload("res://Scenes/arrow.tscn")
@onready var Sprite: Sprite2D = %Sprite
@onready var ChargeBar: ProgressBar = %ChargeBar

var direction: Vector2 = Vector2.RIGHT 
var arrow_speed: float = 600
var charge: float = 0
var charge_rate: float = 100
const MAX_CHARGE: float = 100

func _process(delta: float) -> void:
	direction = global_position.direction_to(get_global_mouse_position()).normalized()
	
	if Input.is_action_pressed("shoot"):
		charge += delta * charge_rate
		if charge >= MAX_CHARGE: 
			charge = MAX_CHARGE
		Sprite.rotation = direction.angle()
	else: 
		Sprite.rotation = Vector2.DOWN.angle() 

	
	if Input.is_action_just_released("shoot"):
		var new_arrow := arrow_scene.instantiate()
		new_arrow.global_position = global_position + (direction * Sprite.texture.get_width())
		new_arrow.velocity = direction * arrow_speed * (charge / 100)
		get_tree().root.add_child(new_arrow)
		charge = 0
	
	ChargeBar.value = charge

func is_charging() -> bool: 
	return Input.is_action_pressed("shoot")
