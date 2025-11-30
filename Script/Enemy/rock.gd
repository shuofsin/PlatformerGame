extends Node2D
class_name Rock

@onready var sprite: Sprite2D = %Sprite
@onready var explosion: AbilityTexture = %Explosion
@onready var collision: Area2D = %Collision


@export var mass: float = 0.25
@export var initial_speed: float = 300

var gravity: float = 9.8
var velocity: Vector2 = Vector2.LEFT
var gravity_vector: Vector2 = Vector2.DOWN
var rotation_rate: float = 10
var has_hit: bool = false

func _ready() -> void:
	sprite.rotation = velocity.angle()
	sprite.visible = true
	collision.body_entered.connect(_on_body_entered)
	explosion.animations.animation_finished.connect(_on_explosion_end)
	explosion.reset_animation()

func _physics_process(delta: float) -> void: 
	if has_hit:
		return 
	
	velocity += gravity_vector * gravity * mass
	position += velocity * delta
	sprite.rotation += delta * rotation_rate

func _on_body_entered(_body_entered: Node2D) -> void:
	explosion.play_animation("explosion")
	has_hit = true

func _on_explosion_end(animation_name: String) -> void: 
	if animation_name == "explosion":
		queue_free()
