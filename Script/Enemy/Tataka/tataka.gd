extends CharacterBody2D
class_name Tataka

@onready var state_machine: StateMachine = %StateMachine
@onready var animations: AnimationPlayer = %Animations
@onready var health_component: HealthComponent = %HealthComponent
@onready var healthbox_component: HealthboxComponent = %HealthboxComponent
@onready var hitbox_component: HitboxComponent = %HitboxComponent

@onready var left_walk_ray: RayCast2D = %LeftWalkRay
@onready var right_walk_ray: RayCast2D = %RightWalkRay
@onready var right_ledge_ray: RayCast2D = %RightLedgeRay
@onready var left_ledge_ray: RayCast2D = %LeftLedgeRay

@onready var sprites: Array[Sprite2D] = [
	%LegBehind, 
	%LegFront, 
	%ArmBehind, 
	%Body, 
	%ArmFront, 
	%Head
]

# Horizontal Movement 
const MAX_SPEED: float = 25
const MAX_SPEED_JUMP: float = 400.0
const ACCELERATION: float = 12.0
const FRICTION: float = 10
var x_direction: float = 1
var x_velocity_weight: float = 0
var is_moving: bool = false

# Vertical Movement 
const JUMP_HEIGHT: float = -300.0
const MIN_GRAVITY: float = 8.0
const MAX_GRAVITY: float = 14.5
const GRAVITY_ACCELERATION: float = 7.5
var gravity: float = MIN_GRAVITY

@export var total_health: float = 5.0

# Player tracking
var direction_to_player: Vector2 = Vector2.ZERO
var distance_to_player: float = INF

# Throw
var rock: PackedScene = preload("res://Scene/Enemy/rock.tscn")
const MAX_ROCK_THROWS: int = 3
var rocks_thrown: int = 0 

func _ready() -> void: 
	health_component.health = total_health
	
	state_machine.ready()

func _process(delta: float) -> void:
	
	if Global.player: 
		direction_to_player = global_position.direction_to(Global.player.global_position)
		distance_to_player = global_position.distance_to(Global.player.global_position)

	if (direction_to_player.angle() < PI / 2) && (direction_to_player.angle() > -PI / 2):
		x_direction = 1
	else:
		x_direction = -1
	
	if x_direction < 0: 
		for sprite in sprites: 
			sprite.flip_h = true
	else: 
		for sprite in sprites: 
			sprite.flip_h = false

	state_machine.process(delta)

func _physics_process(delta: float) -> void:
	x_velocity_weight = delta * (ACCELERATION if is_moving else FRICTION)
	
	if is_on_floor():
		gravity = lerp(gravity, MIN_GRAVITY, GRAVITY_ACCELERATION * delta)
	else: 
		gravity = lerp(gravity, MAX_GRAVITY, GRAVITY_ACCELERATION * delta)
	
	velocity.y += gravity
	
	state_machine.physics_process(delta)
	move_and_slide()

func reset_animation() -> void: 
	animations.play("RESET")
	animations.advance(0)

func throw_rock() -> void: 
	var new_rock: Rock = rock.instantiate()
	var offset: float = 10
	new_rock.global_position = global_position + (direction_to_player * offset)
	new_rock.velocity = direction_to_player * new_rock.initial_speed
	Global.game_manager.world.add_child(new_rock)
