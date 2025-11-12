extends Node2D

@onready var arrow_scene: PackedScene = preload("res://Scenes/arrow.tscn")
@onready var Animations: AnimatedSprite2D = %Animations
@onready var ChargeBar: ProgressBar = %ChargeBar

var direction: Vector2 = Vector2.RIGHT 
var arrow_speed: float = 600
var charge: float = 0
var charge_rate: float = 100
const MAX_CHARGE: float = 100
const IDLE_OFFSET: float = 2
var origin_y: float = 0.0
var is_charged: bool = false

func _ready() -> void: 
	Animations.connect("animation_finished", _charged)
	origin_y = position.y 

func _process(delta: float) -> void:
	direction = global_position.direction_to(get_global_mouse_position()).normalized()
	
	if Input.is_action_pressed("shoot"):
		charge += delta * charge_rate
		if charge >= MAX_CHARGE: 
			charge = MAX_CHARGE
		Animations.rotation = direction.angle()
		if not is_charged: Animations.play("charging")
		Animations.position.y = origin_y
	else: 
		Animations.rotation = Vector2.DOWN.angle() 
		Animations.position.y = origin_y + IDLE_OFFSET
		Animations.play("idle")
		is_charged = false

	
	if Input.is_action_just_released("shoot"):
		var new_arrow := arrow_scene.instantiate()
		var offset := Animations.get_sprite_frames().get_frame_texture("charging", 5).get_width()
		new_arrow.global_position = global_position + (direction * offset)
		new_arrow.velocity = direction * arrow_speed * (charge / 100)
		get_tree().root.add_child(new_arrow)
		charge = 0
	
	ChargeBar.value = charge

func is_charging() -> bool: 
	return Input.is_action_pressed("shoot")

func _charged() -> void: 
	if Animations.animation == "charging":
		Animations.play("holding")
		is_charged = true
	pass
