extends CharacterBody2D
class_name Enemy

@export var health: float = 2
@export var player: Player

func add_health(amount: float) -> void:
	health += amount
