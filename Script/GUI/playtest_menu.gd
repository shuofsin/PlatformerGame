extends Control

@onready var play: Button = %Play
@onready var quit: Button = %Quit
@onready var fade_transition: Control = %FadeTransition

func _ready() -> void:
	play.button_up.connect(_play_game)
	quit.button_up.connect(_quit_game)

func _play_game() -> void: 
	Global.fade_transition.change_scene("playtest_world_one", Global.SCENE_CHANGE_MODE.DELETE, "player_hud", Global.SCENE_CHANGE_MODE.DELETE)

func _quit_game() -> void:
	get_tree().quit()
