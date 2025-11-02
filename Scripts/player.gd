extends CharacterBody2D

@onready var CoyoteTimer: Timer = %CoyoteTimer
@onready var JumpBufferTimer: Timer = %JumpBufferTimer

var coyote_time_activated: bool = false 

# Vertical movement variables
const JUMP_HEIGHT: float = -480.0
const MIN_GRAVITY: float = 12.0
const MAX_GRAVITY: float = 14.5 
var gravity: float = MIN_GRAVITY
const HEAD_NUDGE: float = 3.0
const LEDGE_HOP_FACTOR: float = 7

# Horizontal movement variables
const MAX_SPEED: float = 200.0
const ACCELERATION: float = 20.0
const FRICTION: float = 15.0

# Double jump
const MAX_JUMPS: int = 2
var jumps_completed: int = 0

# Wall sliding and jumping 
const WALL_GRAVITY: float = 15
const WALL_JUMP_PUSH_FORCE: float = 200.0
var wall_contact_coyote: float = 0.0
const WALL_CONTACT_COYOTE_TIME: float = 0.2
var wall_jump_lock: float = 0.0
const WALL_JUMP_LOCK_TIME: float = 0.1
var look_dir_x: int = 1

func _physics_process(delta: float) -> void: 
	# Horizontal movement calculations
	var x_input: float = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	var x_velocity_weight: float = delta * (ACCELERATION if x_input else FRICTION)
	
	# Handle horizontal velocity - accounting for wall jump
	if wall_jump_lock > 0.0:
		wall_jump_lock -= delta
		# velocity.x = lerp(velocity.x, x_input * MAX_SPEED, x_velocity_weight * 0.25)
	else: 
		velocity.x = lerp(velocity.x, x_input * MAX_SPEED, x_velocity_weight)
	
	# Handle wall jump
	if is_on_floor() or wall_contact_coyote > 0.0:
		if Input.is_action_just_pressed("move_jump"):
			velocity.y = JUMP_HEIGHT
			if wall_contact_coyote > 0.0: 
				velocity.x = -look_dir_x * WALL_JUMP_PUSH_FORCE
				wall_jump_lock = WALL_JUMP_LOCK_TIME
	
	# Handle coyote time
	if is_on_floor(): 
		coyote_time_activated = false
		gravity = lerp(gravity, MIN_GRAVITY, MIN_GRAVITY * delta)
		jumps_completed = 0
	else: 
		if CoyoteTimer.is_stopped() and !coyote_time_activated:
			CoyoteTimer.start()
			coyote_time_activated = true
		
		# Cut velocity for variable jump height 
		# Ceiling check to prevent sticking 
		if (Input.is_action_just_released("move_jump") or is_on_ceiling()) and velocity.y < 0:
			velocity.y *= 0.5
		
		gravity = lerp(gravity, MAX_GRAVITY, 12.0 * delta)
	
	# Handle jump input through buffer
	if Input.is_action_just_pressed("move_jump"):
		if JumpBufferTimer.is_stopped():
			JumpBufferTimer.start()
	
	# Preform jump(s)
	if !JumpBufferTimer.is_stopped() and (!CoyoteTimer.is_stopped() or is_on_floor() or jumps_completed < MAX_JUMPS):
		velocity.y = JUMP_HEIGHT
		JumpBufferTimer.stop()
		CoyoteTimer.stop()
		coyote_time_activated = true
		jumps_completed += 1
	
	# Handle head nudge
	if velocity.y < JUMP_HEIGHT/2.0: 
		var head_collision: Array = [$HeadNudgeLeftOne.is_colliding(), $HeadNudgeLeftTwo.is_colliding(), $HeadNudgeRightOne.is_colliding(), $HeadNudgeRightTwo.is_colliding()]
		if head_collision.count(true) == 1:
			if head_collision[0]:
				global_position.x += HEAD_NUDGE
			if head_collision[2]:
				global_position.x -= HEAD_NUDGE
	
	# Handle ledge hopping
	# TODO: Remove hardcoded variables here
	if velocity.y > -30 and velocity.y < -5 and abs(velocity.x) > 3:
		if $LedgeHopLeftOne.is_colliding() and !$LedgeHopLeftTwo.is_colliding() and velocity.x < 0: 
			velocity.y += JUMP_HEIGHT/LEDGE_HOP_FACTOR
		if $LedgeHopRightOne.is_colliding() and !$LedgeHopRightTwo.is_colliding() and velocity.x > 0:
			velocity.y += JUMP_HEIGHT/LEDGE_HOP_FACTOR
	
	# Handle wall sliding 
	if !is_on_floor() and velocity.y > 0 and is_on_wall() and velocity.x != 0:
		look_dir_x = sign(velocity.x)
		wall_contact_coyote = WALL_CONTACT_COYOTE_TIME
		velocity.y = WALL_GRAVITY
		jumps_completed = 0
	else: 
		wall_contact_coyote -= delta
		# Please our Lord Newton
		velocity.y += gravity
	
	# TODO: Handle wall dust
	
	move_and_slide()
