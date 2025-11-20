extends Control

@onready var animations: AnimationPlayer = %Animations
@onready var canvas_layer: CanvasLayer = %CanvasLayer

func change_world(new_world: String, world_mode: int):
	canvas_layer.layer = 2
	animations.play("fade")
	await animations.animation_finished
	Global.game_manager.change_world(new_world, world_mode)
	animations.play_backwards("fade")
	await animations.animation_finished
	canvas_layer.layer = 0

func change_scene(new_world: String, world_mode: int, new_gui: String, gui_mode: int):
	canvas_layer.layer = 2
	animations.play("fade")
	await animations.animation_finished
	Global.game_manager.change_world(new_world, world_mode)
	animations.play_backwards("fade")
	Global.game_manager.change_gui(new_gui, gui_mode)
	await animations.animation_finished
	canvas_layer.layer = 0
