extends Node2D
class_name AbilityManager

@export var weapon: Weapon 
@export var dash: DashStrike

func equip_weapon(weapon_name: String) -> void:
	weapon.queue_free()
	var new_weapon = load(Global.weapons[weapon_name]).instantiate()
	add_child(new_weapon)
	weapon = new_weapon

func equip_dash(dash_name: String) -> void:
	dash.queue_free()
	var new_dash = load(Global.dashes[dash_name]).instantiate()
	add_child(new_dash)
	dash = new_dash
