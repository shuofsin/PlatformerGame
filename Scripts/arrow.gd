extends Area2D
class_name Arrow

var _gravity: float = 9.8
var mass: float = 0.25
var velocity: Vector2 = Vector2.ZERO
var gravity_vector: Vector2 = Vector2.DOWN
var has_hit: bool = false
@export var weapon: Weapon

func _ready() -> void:
	weapon = get_tree().current_scene.find_child("PlayerWeapon")
	body_entered.connect(_on_body_hit)
	area_entered.connect(_on_area_hit)

func _process(delta: float) -> void: 
	if (!has_hit): 
		velocity += gravity_vector * _gravity * mass
		position += velocity * delta
		rotation = velocity.angle()

func _on_body_hit(_body_entered: Node2D) -> void: 
	if !body_entered:
		return
	has_hit = true
	velocity = Vector2.ZERO

func _on_area_hit(_area_entered: Area2D) -> void: 
	if !area_entered:
		return
	if !weapon:
		return 
	if !_area_entered.get_parent():
		return 
	if _area_entered.get_parent() is Enemy: 
		_area_entered.get_parent().add_health(-1)
		weapon.add_dash_charge()
		has_hit = true
		velocity = Vector2.ZERO
