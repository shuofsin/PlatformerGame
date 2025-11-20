extends Control

@onready var play: Button = %Play
@onready var quit: Button = %Quit

func _ready() -> void:
	play.button_up.connect(_play_game)
	quit.button_up.connect(_quit_game)

func _play_game() -> void: 
	Global.game_manager.change_world("playtest_world_one", Global.SCENE_CHANGE_MODE.DELETE)
	Global.game_manager.change_gui("player_hud", Global.SCENE_CHANGE_MODE.DELETE)

func _quit_game() -> void:
	get_tree().quit()
