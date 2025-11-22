extends DashStrike

func _extra_process(_delta: float) -> void:
	if !Global.player:
		return 
	
	Global.player.can_dash = false
