extends Area2D
class_name HelpSign

@onready var text_box: Label = %TextBox
@onready var sprite: Sprite2D = %Sprite
@onready var animations: AnimationPlayer = %Animations

@export_multiline var help_text: String = ""
var has_been_read: bool = false

func ready() -> void: 
	has_been_read = false
	text_box.text = ""
	animations.play("hover_unread")
	area_entered.connect(_display_text)
	area_exited.connect(_remove_text)

func _display_text(_body_entered: CharacterBody2D) -> void: 
	if (body_entered):
		if has_been_read == false: 
			has_been_read = true
			animations.play("hover_read")
		
		text_box.text = help_text

func _remove_text(_body_entered: CharacterBody2D) -> void: 
	if (body_entered):
		text_box.text = ""
