extends CharacterBody2D


@export var walk_speed := 300.0
@export var jump_speed := 400.0
@export var number_of_jumps := 2
 
var _debug := true

func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	# Reset double jump.
	if is_on_floor(): 
		number_of_jumps = 2

	# Handle ground jump.
	if Input.is_action_just_pressed("move_jump") and (is_on_floor() or number_of_jumps > 0):
		velocity.y = jump_speed * -1 
		number_of_jumps -= 1

	# Handle wall jump.
	if Input.is_action_just_pressed("move_jump") and not is_on_floor() and is_on_wall(): 
			velocity.y = jump_speed * -1
			velocity.x = jump_speed * get_wall_normal().x
	
	# Get the input direction and handle the movement/deceleration.a
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)

	move_and_slide()
	
	if _debug: 
		print("On Wall?: " + str(is_on_wall()))
		print("Wall Normal: " + str(get_wall_normal()))
