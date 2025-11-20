extends Node2D
class_name World

@export var spawn: Node2D

func spawn_player() -> void: 
	await spawn
	Global.player.global_position = spawn.global_position
	Global.player.set_process(true)
	Global.player.set_physics_process(true)
