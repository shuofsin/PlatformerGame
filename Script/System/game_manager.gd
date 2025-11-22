extends Node
class_name GameManager

@onready var world: Node2D = %World
@onready var gui: Control = %GUI

@export var current_world: World
@export var current_gui: Control
@export var player: Player

func _ready() -> void: 
	Global.game_manager = self
	Global.player = player
	Global.player.set_player_active(false)

func change_world(new_scene: String, mode: int) -> void: 
	if current_world: 
		if mode == Global.SCENE_CHANGE_MODE.DELETE: 
			current_world.queue_free()
		elif mode == Global.SCENE_CHANGE_MODE.HIDE: 
			current_world.visible = false # Should almost never be used, will cause issues
		elif mode == Global.SCENE_CHANGE_MODE.REMOVE:
			world.remove_child(current_world)
	var new_world = load(Global.worlds[new_scene]).instantiate()
	world.add_child(new_world)
	current_world = new_world
	current_world.spawn_player()

func change_gui(new_scene: String, mode: int) -> void: 
	if current_gui:
		if mode == Global.SCENE_CHANGE_MODE.DELETE: 
			current_gui.queue_free()
		elif mode == Global.SCENE_CHANGE_MODE.HIDE: 
			current_gui.visible = false
		elif mode == Global.SCENE_CHANGE_MODE.REMOVE:
			gui.remove_child(current_gui)
	var new_gui = load(Global.guis[new_scene]).instantiate()
	gui.add_child(new_gui)
	current_gui = new_gui
