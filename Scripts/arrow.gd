extends Area2D


var _gravity: float = 9.8
var mass: float = 0.25
var velocity: Vector2 = Vector2.ZERO
var gravity_vector: Vector2 = Vector2.DOWN
var has_hit: bool = false

func _ready() -> void:
	body_entered.connect(_on_wall_hit)

func _process(delta: float) -> void: 
	if (!has_hit): 
		velocity += gravity_vector * _gravity * mass
		position += velocity * delta
		rotation = velocity.angle()

func _on_wall_hit(body_entered: Node2D) -> void: 
	has_hit = true
