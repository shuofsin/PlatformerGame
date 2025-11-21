extends Node

var debug: bool = false
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var game_manager: GameManager 
var player: Player
enum SCENE_CHANGE_MODE {
	DELETE = 1, # No memory, no data
	HIDE = 2, # In memory, running
	REMOVE = 3 # In memory, not running
}
var worlds: Dictionary = {
	"playtest_world_one": "res://Scenes/Levels/playtest_world_one.tscn",
	"playtest_world_two": "res://Scenes/Levels/playtest_world_two.tscn",
	"playtest_world_three": "res://Scenes/Levels/playtest_world_three.tscn"
}
var guis: Dictionary = {
	"playtest_menu": "res://Scenes/GUI/playtest_menu.tscn",
	"player_hud": "res://Scenes/GUI/player_hud.tscn",
	"splash_screen": "res://Scenes/GUI/splash_screen.tscn"
}
