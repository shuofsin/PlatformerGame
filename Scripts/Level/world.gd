extends Node2D
class_name World

@export var spawn: Node2D

func spawn_player() -> void: 
	await get_tree().process_frame
	Global.player.global_position = spawn.global_position
	Global.player.set_player_active(true)
