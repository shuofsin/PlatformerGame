extends Control

@onready var animations: AnimationPlayer = %Animations

func _ready() -> void:
	animations.play("name")
	animations.animation_finished.connect(_go_to_main)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_go_to_main("name")

func _go_to_main(_animation_name: String) -> void:
	Global.game_manager.change_gui("playtest_menu", Global.SCENE_CHANGE_MODE.DELETE)
