extends Control

@onready var health_bar: BarTexture = %HealthBar
@onready var dash_bar: Sprite2D = %DashBar

func _process(_delta: float) -> void:
	if !Global.player:
		return
	
	if Global.player.can_dash: 
		dash_bar.frame = 1
	else:
		dash_bar.frame = 0
	
	health_bar.set_value(Global.player.get_health_percentage())
