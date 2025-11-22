extends BoarState
class_name BoarDeathState

func enter() -> void: 
	boar.queue_free()
