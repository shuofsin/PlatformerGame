extends Node
class_name StateMachine

var states: Dictionary = {}
var current_state: State
@export var initial_state: State

func ready() -> void: 
	for child in get_children():
		if child is State: 
			states[child.name.to_lower()] = child
			child.transition.connect(change_state)
	
	if initial_state: 
		initial_state.enter()
		current_state = initial_state
	pass

func change_state(old_state: State, new_state_name: String) -> void:
	if old_state != current_state: 
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return 
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state

func process(delta: float) -> void: 
	if current_state: 
		current_state.update(delta)

func physics_process(delta: float) -> void: 
	if current_state: 
		current_state.physics_update(delta)

func force_change_state(new_state_name: String):
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state: 
		return
	
	if current_state == new_state: 
		return
	
	if current_state:
		current_state.exit.call_deferred()
	
	new_state.enter()
	current_state = new_state
