extends Node

var debug: bool = false
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var game_manager: GameManager 
var fade_transition: Control
var player: Player
enum SCENE_CHANGE_MODE {
	DELETE = 1, # No memory, no data
	HIDE = 2, # In memory, running
	REMOVE = 3 # In memory, not running
}
enum ITEM_TYPE {
	WEAPON,
	DASH
}
var worlds: Dictionary = {
	"playtest_world_one": "res://Scene/Level/playtest_world_one.tscn",
	"playtest_world_two": "res://Scene/Level/playtest_world_two.tscn",
	"playtest_world_three": "res://Scene/Level/playtest_world_three.tscn",
	"playtest_world_four": "res://Scene/Level/playtest_world_four.tscn"
}
var guis: Dictionary = {
	"playtest_menu": "res://Scene/GUI/playtest_menu.tscn",
	"player_hud": "res://Scene/GUI/player_hud.tscn",
	"splash_screen": "res://Scene/GUI/splash_screen.tscn"
}
var weapons: Dictionary = {
	"basic_bow": "res://Scene/Ability/Bow/basic_bow.tscn",
	"faster_bow": "res://Scene/Ability/Bow/faster_bow.tscn"
}
var dashes: Dictionary = {
	"basic_dash": "res://Scene/Ability/DashStrike/basic_dash_strike.tscn",
	"better_dash": "res://Scene/Ability/DashStrike/better_dash_strike.tscn"
}
