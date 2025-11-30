extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 1
var health: float 
@export var death_state: State
@export var state_machine: StateMachine

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	
	if !death_state: 
		return 
	
	if !state_machine:
		return 
	
	if get_parent().velocity != null:
		var knockback_direction = attack.attack_position.direction_to(get_parent().global_position)
		knockback_direction.rotated(Global.rng.randf_range(-(PI / 4), (PI / 4)))
		get_parent().velocity = knockback_direction * attack.knockback_force
	if health <= 0:
		state_machine.force_change_state(death_state.name)
