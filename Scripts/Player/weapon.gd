extends Node2D
class_name Weapon

@onready var arrow_scene: PackedScene = preload("res://Scenes/Player/arrow.tscn")
@onready var Animations: AnimatedSprite2D = %Animations
@onready var ChargeBar: ProgressBar = %ChargeBar

@export var player: CharacterBody2D

var direction: Vector2 = Vector2.RIGHT 
var arrow_speed: float = 600
var charge_amount: float = 0
var charge_rate: float = 100
const MAX_CHARGE: float = 100
const IDLE_OFFSET: float = 2
var origin_y: float = 0.0
enum {IDLE, CHARGING, CHARGED, RELEASE}
var current_state: int = IDLE 

func _ready() -> void: 
	Animations.connect("animation_finished", _charged)
	origin_y = position.y 

func _process(delta: float) -> void:
	direction = global_position.direction_to(get_global_mouse_position()).normalized()
	ChargeBar.value = charge_amount
	if (current_state == IDLE):
		_idle()
	if (current_state == CHARGING):
		_charging(delta)
	if (current_state == CHARGED):
		_charged()
	if (current_state == RELEASE):
		_release() 

func add_dash_charge(): 
	player.can_dash = true

func draw_weapon() -> void: 
	current_state = CHARGING 

func release_weapon() -> void: 
	current_state = RELEASE

func is_drawn() -> bool:
	return current_state == CHARGING || current_state == CHARGED

func reset() -> void: 
	current_state = IDLE

func _idle() -> void: 
	charge_amount = 0
	Animations.rotation = Vector2.DOWN.angle() 
	Animations.position.y = origin_y + IDLE_OFFSET
	Animations.play("idle")

func _charging(delta: float) -> void: 
	charge_amount += delta * charge_rate
	if charge_amount >= MAX_CHARGE: 
		charge_amount = MAX_CHARGE
		current_state = CHARGED
	
	Animations.rotation = direction.angle()
	Animations.position.y = origin_y
	Animations.play("charging")

func _charged() -> void: 
	Animations.play("holding")

func _release() -> void: 
	var new_arrow := arrow_scene.instantiate()
	var offset := Animations.get_sprite_frames().get_frame_texture("charging", 5).get_width()
	new_arrow.global_position = global_position + (direction * offset)
	new_arrow.velocity = direction * arrow_speed * (charge_amount / 100)
	new_arrow.weapon = self
	Global.game_manager.world.add_child(new_arrow)
	current_state = IDLE
