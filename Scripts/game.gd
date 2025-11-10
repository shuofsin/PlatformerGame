extends Node2D

var _debug: bool = true
@onready var Player: CharacterBody2D = %Player
@onready var DebugScreen: Label = %DebugScreen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _debug: 
		DebugScreen.text = ""
	else: 
		DebugScreen.text = ""
