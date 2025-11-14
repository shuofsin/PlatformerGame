extends CharacterBody2D

#Nodes
@onready var CoyoteTimer: Timer = %CoyoteTimer
@onready var JumpBufferTimer: Timer = %JumpBufferTimer
@onready var Animations: AnimationPlayer = %Animations
@onready var Sprites: Sprite2D = %Sprites
@onready var HeadSprite: Sprite2D = %HeadSprite
@onready var BodySprite: Sprite2D = %BodySprite
@onready var Weapon: Node2D = %Weapon
@onready var Camera: Camera2D = %Camera

# Vertical movement variables
const JUMP_HEIGHT: float = -300.0
const MIN_GRAVITY: float = 9.0
const MAX_GRAVITY: float = 12.5 
const GRAVITY_ACCELERATION: float = 8.0
var gravity: float = MIN_GRAVITY
const HEAD_NUDGE: float = 1.5
const LEDGE_HOP_FACTOR: float = 7
var coyote_time_activated: bool = false 

# Horizontal movement variables
const MAX_SPEED: float = 150.0
const ACCELERATION: float = 12.0
const FRICTION: float = 10

# Double jump
const MAX_JUMPS: int = 1
var jumps_completed: int = 0

# Wall sliding and jumping 
const WALL_GRAVITY: float = 7.5
const WALL_JUMP_PUSH_FORCE: float = 125.0
var wall_contact_coyote: float = 0.0
const WALL_CONTACT_COYOTE_TIME: float = 0.2
var wall_jump_lock: float = 0.0
const WALL_JUMP_LOCK_TIME: float = 0.5
var look_dir_x: int = 1

# Camera motion
const MIN_ZOOM: float = 3.0
const MAX_ZOOM: float = 5.0
const ZOOM_RATE: float = 1.25

# Air Dash
const DASH_AMOUNT: float = 250
const DASH_TIME: float = 0.25

var can_dash: bool = true
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.RIGHT
var final_dash_direction: Vector2 = Vector2.RIGHT
var dash_timer: float = 0.0

func _physics_process(delta: float) -> void: 
	var x_input: float = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	if !is_dashing: 
		# Horizontal movement calculations
		var x_velocity_weight: float = delta * (ACCELERATION if x_input else FRICTION)
		
		# Handle horizontal velocity - accounting for wall jump
		if wall_jump_lock > 0.0:
			wall_jump_lock -= delta
		else: 
			velocity.x = lerp(velocity.x, x_input * MAX_SPEED, x_velocity_weight)
	
	# Handle wall jump
	if wall_contact_coyote > 0.0:
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
		
		gravity = lerp(gravity, MAX_GRAVITY, GRAVITY_ACCELERATION * delta)
	
	if !is_dashing: 
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
	
	if !is_dashing:
		# Handle wall sliding 
		if !is_on_floor() and velocity.y > 0 and is_on_wall() and velocity.x != 0:
			look_dir_x = sign(velocity.x)
			wall_contact_coyote = WALL_CONTACT_COYOTE_TIME
			velocity.y = WALL_GRAVITY
		else: 
			wall_contact_coyote -= delta
			# Please our Lord Newton
			velocity.y += gravity
	
	_dash_logic(delta)
	move_and_slide()
	
	# Handle animations
	if is_dashing: 
		Animations.play("dash")
		Sprites.rotation = final_dash_direction.angle()
		HeadSprite.rotation = 0
		BodySprite.flip_h = false 
		if Sprites.rotation > (PI/2) or Sprites.rotation < (-PI/2):
			print("Triggering!")
			BodySprite.flip_v = true
			HeadSprite.flip_v = true
		else: 
			BodySprite.flip_v = false
			HeadSprite.flip_v = false
		Weapon.visible = false
	else: 
		Sprites.rotation = 0.0
		BodySprite.flip_v = false
		Weapon.visible = true
		if velocity.x > 0: 
			BodySprite.flip_h = false 
		if velocity.x < 0: 
			BodySprite.flip_h = true
		if x_input == 0 and is_on_floor(): 
			Animations.play("idle")
		elif x_input and is_on_floor():
			Animations.play("walk")
		elif !is_on_floor() and velocity.y > 0 and is_on_wall():
			Animations.play("wall")
		elif !is_on_floor() and velocity.y < 0: 
			Animations.play("jump")
		elif !is_on_floor() and velocity.y > 0: 
			Animations.play("fall")
	
	if (!is_dashing):
		HeadSprite.rotation = HeadSprite.global_position.direction_to(get_global_mouse_position()).angle()
		if HeadSprite.rotation > (PI/2) or HeadSprite.rotation < (-PI/2):
			HeadSprite.flip_v = true
		else: 
			HeadSprite.flip_v = false
	
	# Handle zoom 
	if Weapon.is_charging(): 
		Camera.zoom = lerp(Camera.zoom, Vector2(MIN_ZOOM, MIN_ZOOM), ZOOM_RATE * delta) 
	else: 
		Camera.zoom = lerp(Camera.zoom, Vector2(MAX_ZOOM, MAX_ZOOM), ZOOM_RATE * delta)
	
	# Handle dash
	if is_on_floor(): 
		if !is_dashing and !can_dash: 
			can_dash = true

func _dash_logic(delta: float) -> void: 
	
	dash_direction = global_position.direction_to(get_global_mouse_position()).normalized()
	
	if can_dash and Input.is_action_just_pressed("move_dash"):
		final_dash_direction = dash_direction
		
		can_dash = false 
		is_dashing = true
		dash_timer = DASH_TIME
		
		velocity = final_dash_direction * DASH_AMOUNT
	
	if is_dashing:
		dash_timer -= delta 
		if dash_timer <= 0.0:
			is_dashing = false
