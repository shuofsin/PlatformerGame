extends Node2D
class_name World

@export var spawn_position: Vector2

func spawn_player() -> void: 
	Global.player.global_position = spawn_position
