extends Area2D
class_name Arrow

var _gravity: float = 9.8
var mass: float = 0.25
var velocity: Vector2 = Vector2.ZERO
var gravity_vector: Vector2 = Vector2.DOWN
var has_hit: bool = false
const TIME_TO_DESPAWN: float = 2
var despawn_timer: float = 0
const TIME_TO_FADE: float = 1
@export var weapon: Weapon

## Find the weapon node, and connect signals
func _ready() -> void:
	weapon = get_tree().current_scene.find_child("PlayerWeapon")
	body_entered.connect(_on_body_hit)
	area_entered.connect(_on_area_hit)

## If you haven't hit anything, move
func _process(delta: float) -> void: 
	if (!has_hit): 
		velocity += gravity_vector * _gravity * mass
		position += velocity * delta
		rotation = velocity.angle()

	if has_hit and despawn_timer >= 0:
		despawn_timer -= delta 
	elif has_hit:
		var tween_fade = create_tween()
		tween_fade.tween_property(self, "modulate", Color(1, 1, 1, 0), TIME_TO_FADE)
		tween_fade.finished.connect(queue_free)

## If a physical body has been hit, stop moving and start the despawn timer
func _on_body_hit(_body_entered: Node2D) -> void: 
	if !body_entered:
		return
	_stop_moving()

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
		_stop_moving()

func _stop_moving() -> void: 
	has_hit = true
	velocity = Vector2.ZERO
	despawn_timer = TIME_TO_DESPAWN
