extends Node2D
class_name Rock

var gravity: float = 9.8
@export var mass: float = 0.01
var velocity: Vector2 = Vector2.LEFT
var gravity_vector: Vector2 = Vector2.DOWN
@export var initial_speed: float = 300
@onready var sprite: Sprite2D = %Sprite
var rotation_rate: float = 10

func _ready() -> void:
	sprite.rotation = velocity.angle()

func _physics_process(delta: float) -> void: 	
	velocity += gravity_vector * gravity * mass
	position += velocity * delta
	sprite.rotation += delta * rotation_rate
	
