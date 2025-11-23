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
	if get_parent().velocity != null:
		var knockback_direction = 1 if attack.attack_position.x < global_position.x else -1
		get_parent().velocity = Vector2(attack.knockback_force * knockback_direction * 1.5, -attack.knockback_force)
	if health <= 0:
		state_machine.force_change_state(death_state.name)
