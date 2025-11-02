extends Node2D

var _debug: bool = false
@onready var Player: CharacterBody2D = %Player
@onready var DebugScreen: Label = %DebugScreen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _debug: 
		DebugScreen.text = ("Player Y Velocity: " + str(Player.velocity.y) + 
		"\nPlayer X Velocity: " + str(Player.velocity.x) + 
		"\nJumps Completed: " + str(Player.jumps_completed) + 
		"\nWall Lock Time: " + str(Player.wall_jump_lock))
	else: 
		DebugScreen.text = ""
