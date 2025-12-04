extends Node2D
class_name Weapon

signal fired

@export var arrow_type: PackedScene
@export var weapon_texture: AbilityTexture

var direction: Vector2 = Vector2.RIGHT 
@export var charge_amount: float = 0
@export var charge_rate: float = 200
@export var max_charge: float = 100
enum {IDLE, CHARGING, RELEASE}
var current_state: int = IDLE 
var is_active: bool = true

func _ready() -> void: 
	weapon_texture.play_animation("RESET")
	_extra_ready()

func _process(delta: float) -> void:
	_extra_process(delta)
	if !is_active:
		return
	
	direction = _calculate_direction_vector()
	
	if (current_state == IDLE):
		reset()
	if (current_state == CHARGING):
		_charging(delta)
	if (current_state == RELEASE):
		_release() 

func _calculate_direction_vector() -> Vector2: 
	var angle = global_position.direction_to(get_global_mouse_position()).normalized().angle()
	if angle > (- PI / 4) && angle < (PI / 4):
		return Vector2.RIGHT
	if angle > (PI / 4) && angle < (3 * PI / 4):
		return Vector2.DOWN  
	if abs(angle) > (3 * PI / 4):
		return Vector2.LEFT
	return Vector2.UP

func _physics_process(delta: float) -> void:
	_extra_physics_process(delta)

func add_dash_charge(): 
	Global.player.can_dash = true

func fire_weapon() -> void: 
	if current_state == CHARGING:
		return 
	current_state = CHARGING 
	weapon_texture.play_animation("charging")

func release_weapon() -> void: 
	current_state = RELEASE

func is_drawn() -> bool:
	return current_state == CHARGING

func reset() -> void: 
	fired.emit()
	charge_amount = 0
	weapon_texture.rotation = 0.0
	weapon_texture.play_animation("idle")

func _charging(delta: float) -> void: 
	charge_amount += delta * charge_rate
	if charge_amount >= max_charge: 
		charge_amount = max_charge
		_release()
		current_state = IDLE
	
	weapon_texture.rotation = direction.angle()

func _release() -> void: 
	if !arrow_type: 
		return 
	var new_arrow: Arrow = arrow_type.instantiate()
	var offset: float = weapon_texture.get_offset()
	new_arrow.global_position = global_position + (direction * offset)
	new_arrow.velocity = direction * new_arrow.initial_speed * (charge_amount / max_charge)
	new_arrow.hitbox_component.attack.attack_damage *= (charge_amount / max_charge)
	new_arrow.weapon = self
	Global.game_manager.world.add_child(new_arrow)
	current_state = IDLE

func _extra_ready() -> void: 
	pass

func _extra_process(_delta: float) -> void:
	pass
	
func _extra_physics_process(_delta: float) -> void:
	pass
