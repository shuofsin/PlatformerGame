extends CharacterBody2D
class_name Boar

@onready var health_sprite: Sprite2D = %HealthSprite
@onready var state_machine: StateMachine = $StateMachine
@onready var animations: AnimationPlayer = %Animations
@onready var body_sprite: Sprite2D = %BodySprite
@onready var health_component: HealthComponent = %HealthComponent
@onready var healthbox_component: Area2D = %HealthboxComponent
@onready var hitbox_component: HitboxComponent = %HitboxComponent

# Horizontal Movement 
const MAX_SPEED_ROAM: float = 25.0
const MAX_SPEED_RUN: float = 155.0
const ACCELERATION: float = 12.0
const FRICTION: float = 10
@export_range(-1, 1, 1) var x_direction: float = 0
var x_velocity_weight: float = 0
var is_moving: bool = false

# Vertical Movement 
const MIN_GRAVITY: float = 8.0
const MAX_GRAVITY: float = 14.5
const GRAVITY_ACCELERATION: float = 7.5
var gravity: float = MIN_GRAVITY

# idle 
var time_to_idle: float = 2
var idle_timer: float = 0

# Roam 
@export var time_to_roam: float = 4
var roam_timer: float = 0
@onready var roam_left: RayCast2D = %RoamLeft
@onready var roam_right: RayCast2D = %RoamRight
@onready var attack_left: RayCast2D = %AttackLeft
@onready var attack_right: RayCast2D = %AttackRight

# Run 
@export var run_distance: float = 100.0
var direction_to_player: Vector2
var distance_to_player: float = INF

# Attack
const HITBOX_OFFSET: float = 6.25

func _ready() -> void:
	state_machine.ready()


func _process(delta: float) -> void:
	health_sprite.frame = health_component.health
	
	if Global.player: 
		direction_to_player = global_position.direction_to(Global.player.global_position)
		distance_to_player = global_position.distance_to(Global.player.global_position)

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

func _check_for_player_run() -> void: 
	if distance_to_player < run_distance:
		state_machine.force_change_state("run")

func _check_for_player_attack() -> void: 
	if attack_left.is_colliding() || attack_right.is_colliding():
		state_machine.force_change_state("attack")
