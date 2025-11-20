extends Area2D
class_name WorldTransition

@export var world_to_go: String
@export var world_change_mode: Global.SCENE_CHANGE_MODE = Global.SCENE_CHANGE_MODE.REMOVE

func _ready() -> void: 
	set_collision_mask_value(2, true)
	body_entered.connect(_on_player_entered)

func _on_player_entered(body: Node2D) -> void: 
	if body is Player: 
		set_collision_mask_value(2, false)
		Global.game_manager.change_world(world_to_go, world_change_mode)
