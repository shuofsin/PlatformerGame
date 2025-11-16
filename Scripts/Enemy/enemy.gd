extends CharacterBody2D
class_name Enemy

var health: float = 2
@onready var health_sprite: Sprite2D = %HealthSprite

func _process(_delta: float) -> void:
	health_sprite.frame = health
	if health <= 0: 
		queue_free()

func add_health(amount: float) -> void:
	health += amount
