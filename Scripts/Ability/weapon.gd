extends Node2D
class_name Weapon

@export var arrow_type: PackedScene
@export var weapon_texture: AbilityTexture
@export var charge_bar_texture: BarTexture

var direction: Vector2 = Vector2.RIGHT 
@export var charge_amount: float = 0
@export var charge_rate: float = 100
@export var max_charge: float = 100
const IDLE_OFFSET: float = 2
var origin_y: float = 0.0
enum {IDLE, CHARGING, CHARGED, RELEASE}
var current_state: int = IDLE 

func _ready() -> void: 
	weapon_texture.play_animation("RESET")
	charge_bar_texture.set_value(charge_amount / max_charge)
	origin_y = position.y 

func _process(delta: float) -> void:
	direction = global_position.direction_to(get_global_mouse_position()).normalized()
	charge_bar_texture.set_value(charge_amount / max_charge)
	if (current_state == IDLE):
		_idle()
	if (current_state == CHARGING):
		_charging(delta)
	if (current_state == CHARGED):
		_charged()
	if (current_state == RELEASE):
		_release() 

func add_dash_charge(): 
	Global.player.can_dash = true

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
	weapon_texture.rotation = Vector2.DOWN.angle() 
	weapon_texture.position.y = origin_y + IDLE_OFFSET
	weapon_texture.play_animation("idle")

func _charging(delta: float) -> void: 
	charge_amount += delta * charge_rate
	if charge_amount >= max_charge: 
		charge_amount = max_charge
		current_state = CHARGED
	
	weapon_texture.rotation = direction.angle()
	weapon_texture.position.y = origin_y
	weapon_texture.play_animation("charging")

func _charged() -> void: 
	weapon_texture.play_animation("holding")

func _release() -> void: 
	var new_arrow: Arrow = arrow_type.instantiate()
	var offset: float = weapon_texture.get_offset()
	new_arrow.global_position = global_position + (direction * offset)
	new_arrow.set_velocity(direction, charge_amount / max_charge)
	new_arrow.weapon = self
	if !Global.game_manager: 
		get_tree().current_scene.add_child(new_arrow)
	else:
		Global.game_manager.world.add_child(new_arrow)
	current_state = IDLE
