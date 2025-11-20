extends Control

@onready var dash_charge_icon: Sprite2D = %DashChargeIcon
@onready var health_icon: Sprite2D = %HealthIcon


func _process(_delta: float) -> void:
	if !Global.player:
		return
	
	if Global.player.can_dash: 
		dash_charge_icon.frame = 0
	else:
		dash_charge_icon.frame = 1
	
	health_icon.frame = min(Global.player.health_component.health, 5)
