extends PlayerState
class_name PlayerDeathState

func enter() -> void: 
	get_tree().reload_current_scene()
