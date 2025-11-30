extends CharacterBody2D
class_name Player

@onready var state_machine: StateMachine = %StateMachine 
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var jump_buffer_timer: Timer = %JumpBufferTimer
@onready var sprites: Sprite2D = %Sprites
@onready var animations: AnimationPlayer = %Animations
@onready var body_sprite: Sprite2D = %BodySprite
@onready var head_sprite: Sprite2D = %HeadSprite
@onready var debug: Label = %Debug
@onready var health_component: HealthComponent = %HealthComponent
@onready var healthbox_component: HealthboxComponent = %HealthboxComponent
@onready var ability_manager: AbilityManager = %AbilityManager


# Vertical movement variables
const JUMP_HEIGHT: float = -225.0
const MIN_GRAVITY: float = 8.0
const MAX_GRAVITY: float = 12.5 
const GRAVITY_ACCELERATION: float = 7.5
var gravity: float = MIN_GRAVITY
const HEAD_NUDGE: float = 1.5
const LEDGE_HOP_FACTOR: float = 7
var coyote_time_activated: bool = false 

# Horizontal movement variables
const MAX_SPEED_NORMAL: float = 115.0
const MAX_SPEED_WEAPON: float = 50.0
var max_speed: float = MAX_SPEED_NORMAL
const ACCELERATION: float = 12.0
const FRICTION: float = 10
var x_input: float = 0
var x_velocity_weight: float = 0

# Wall sliding and jumping 
const WALL_GRAVITY: float = 7.5
const WALL_JUMP_PUSH_FORCE: float = 125.0
var wall_contact_coyote: float = 0.0
const WALL_CONTACT_COYOTE_TIME: float = 0.2
var wall_jump_lock: float = 0.0
const WALL_JUMP_LOCK_TIME: float = 0.5
var look_dir_x: int = 1

# Air Dash
const DASH_BUFFER: float = 0.05

var is_dashing: bool = false
var can_dash: bool = false
var dash_direction: Vector2 = Vector2.RIGHT
var dash_timer: float = 0.0

# Ghosting for air dash 
var ghost_sprite: PackedScene = preload("res://Scene/Player/player_ghost_effect.tscn")
var ghost_timer: float = 0
var time_between_ghosts: float = 0.05

# Weapon tracking
var is_weapon_charging: bool = false

# Health
var total_health: float = 100.0

func _ready() -> void:
	health_component.health = total_health
	state_machine.ready()
	pass 

func _process(delta: float) -> void:
	x_input = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	if velocity.x < 0:
		body_sprite.flip_h = true
	elif velocity.x > 0:
		body_sprite.flip_h = false 
	
	# Handle jump input through buffer
	if Input.is_action_just_pressed("move_jump"):
		if jump_buffer_timer.is_stopped():
			jump_buffer_timer.start()
	
	# Preform jump
	if !jump_buffer_timer.is_stopped() and (!coyote_timer.is_stopped() or is_on_floor()):
		state_machine.force_change_state("jump")
	
	# Preform wall jump
	if wall_contact_coyote > 0.0 and state_machine.current_state.name.to_lower() == "wallslide":
		if Input.is_action_just_pressed("move_jump"):
			state_machine.force_change_state("walljump")
	
	if can_dash and Input.is_action_just_pressed("move_dash"):
		state_machine.force_change_state("dash")
	
	state_machine.process(delta)
	if (!is_dashing):
		_weapon_logic()
		_head_rotation_logic()
	_debug(Global.debug)

func _physics_process(delta: float) -> void:
	x_velocity_weight = delta * (ACCELERATION if x_input else FRICTION)
	
	if coyote_timer.is_stopped() and !coyote_time_activated and !is_on_floor():
		coyote_timer.start()
		coyote_time_activated = true
		
		gravity = lerp(gravity, MAX_GRAVITY, GRAVITY_ACCELERATION * delta)

	# Handle head nudge
	if velocity.y < JUMP_HEIGHT/2.0: 
		var head_collision: Array = [$HeadNudgeLeftOne.is_colliding(), $HeadNudgeLeftTwo.is_colliding(), $HeadNudgeRightOne.is_colliding(), $HeadNudgeRightTwo.is_colliding()]
		if head_collision.count(true) == 1:
			if head_collision[0]:
				global_position.x += HEAD_NUDGE
			if head_collision[2]:
				global_position.x -= HEAD_NUDGE
		
	# Handle ledge hopping
	if velocity.y > -30 and velocity.y < -5 and abs(velocity.x) > 3:
		if $LedgeHopLeftOne.is_colliding() and !$LedgeHopLeftTwo.is_colliding() and velocity.x < 0: 
			velocity.y += JUMP_HEIGHT/LEDGE_HOP_FACTOR
		if $LedgeHopRightOne.is_colliding() and !$LedgeHopRightTwo.is_colliding() and velocity.x > 0:
			velocity.y += JUMP_HEIGHT/LEDGE_HOP_FACTOR

	state_machine.physics_process(delta)
	move_and_slide()
	pass

func set_player_active(is_active: bool) -> void: 
	state_machine.force_change_state("idle")
	set_process(is_active)
	set_physics_process(is_active)
	set_weapon_active(is_active)

func run_gravity(delta: float) -> void: 
	velocity.y += gravity 
	wall_contact_coyote -= delta

func _debug(is_on: bool) -> void: 
	if is_on:
		debug.text = str(is_dashing)
	else:
		debug.text = ""

func set_weapon_active(is_active: bool) -> void: 
	ability_manager.weapon.set_process(is_active)
	ability_manager.weapon.set_physics_process(is_active)
	if !is_active:
		ability_manager.weapon.reset()

func _weapon_logic() -> void: 
	if ability_manager.weapon.name.to_lower() == "emptybow":
		return
	if Input.is_action_just_pressed("shoot"):
		ability_manager.weapon.draw_weapon()
		max_speed = MAX_SPEED_WEAPON
		is_weapon_charging = true
	if Input.is_action_just_released("shoot"):
		ability_manager.weapon.release_weapon()
		max_speed = MAX_SPEED_NORMAL
		is_weapon_charging = false

func _head_rotation_logic() -> void: 
	head_sprite.rotation = head_sprite.global_position.direction_to(get_global_mouse_position()).angle()
	if head_sprite.rotation > (PI/2) or head_sprite.rotation < (-PI/2):
		head_sprite.flip_v = true
	else: 
		head_sprite.flip_v = false

func get_health_percentage() -> float:
	return health_component.health / total_health
