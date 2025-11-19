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
