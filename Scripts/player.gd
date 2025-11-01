extends CharacterBody2D

var _debug := true

@export var walk_speed := 300.0
@export var jump_speed := 400.0
@export var number_of_jumps := 2

@onready var _wall_dust_right: GPUParticles2D = %WallDustRight
@onready var _wall_dust_left: GPUParticles2D = %WallDustLeft

const GRAVITY_NORMAL := 980.0
const GRAVITY_WALL := 450.0

func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity.y = GRAVITY_NORMAL * delta

	
	# Reset double jump.
	if is_on_floor(): 
		number_of_jumps = 2

	# Handle ground jump.
	if Input.is_action_just_pressed("move_jump") and (is_on_floor() or number_of_jumps > 0):
		velocity.y = jump_speed * -1 
		number_of_jumps -= 1

	# Wall normal vector points the oppisite direction of the wall
	# Wall dust
	if not is_on_floor() and velocity.y > 0:
		_wall_dust_right.emitting = (is_on_wall() and get_wall_normal() == Vector2.LEFT)
		_wall_dust_left.emitting = (is_on_wall() and get_wall_normal() == Vector2.RIGHT)
	else: 
		_wall_dust_right.emitting = false
		_wall_dust_left.emitting = false
		_gravity_multiplier = 1

	# Simple wall slide
	_gravity_multiplier = 0.5 if is_on_wall() else 1

	# Get the input direction and handle the movement/deceleration.a
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)

	move_and_slide()
	
	if _debug: 
		print("Gravity Multiplier: " + str(_gravity_multiplier))
