extends Area2D
class_name HitboxComponent

@export var attack: Attack

func _ready() -> void:
	area_entered.connect(_on_healthbox_area_entered)

func _on_healthbox_area_entered(area: Area2D) -> void: 
	if area is HealthboxComponent:
		attack.attack_position = global_position
		area.damage(attack)
