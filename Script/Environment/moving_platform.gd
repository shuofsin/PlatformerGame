extends AnimatableBody2D

@onready var ray_right: RayCast2D = %RayRight
@onready var ray_left: RayCast2D = %RayLeft

const SPEED: float = 75
enum Directions {LEFT = -1, RIGHT = 1}
@export var direction: Directions

func _physics_process(delta: float) -> void:
	position.x += delta * (SPEED * direction)
	
	if ray_right.is_colliding():
		direction = Directions.LEFT
	if ray_left.is_colliding(): 
		direction = Directions.RIGHT
