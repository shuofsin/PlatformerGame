extends Area2D
class_name ForestSpikes

func _ready() -> void:
	body_entered.connect(_is_player_entered)


func _is_player_entered(body_entered: Node2D):
	if body_entered is Player: 
		body_entered.state_machine.force_change_state("death")
