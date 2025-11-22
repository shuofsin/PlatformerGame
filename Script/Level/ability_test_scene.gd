extends Node2D

@onready var weapon: Weapon = %Weapon

func _process(delta: float) -> void: 
	if Input.is_action_just_pressed("shoot"):
		weapon.draw_weapon()
	if Input.is_action_just_released("shoot"):
		weapon.release_weapon()
