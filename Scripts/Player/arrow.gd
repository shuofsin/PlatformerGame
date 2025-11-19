extends Node2D
class_name Arrow


@onready var hitbox_component: HitboxComponent = %HitboxComponent
@onready var collision: Area2D = %Collision
var weapon: Weapon

var _gravity: float = 9.8
var mass: float = 0.25
var velocity: Vector2 = Vector2.ZERO
var gravity_vector: Vector2 = Vector2.DOWN

var has_hit: bool = false
const TIME_TO_DESPAWN: float = 2
var despawn_timer: float = 0
const TIME_TO_FADE: float = 1

## Set continous collisions
func _ready() -> void: 
	collision.body_entered.connect(_on_body_entered)

## If you haven't hit anything, move
## If you have hit something, disappear over time
func _process(delta: float) -> void: 
	if has_hit and despawn_timer >= 0:
		despawn_timer -= delta 
	elif has_hit:
		var tween_fade = create_tween()
		tween_fade.tween_property(self, "modulate", Color(1, 1, 1, 0), TIME_TO_FADE)
		tween_fade.finished.connect(queue_free)

func _physics_process(delta: float) -> void: 	
	if (!has_hit): 
		velocity += gravity_vector * _gravity * mass
		position += velocity * delta
		rotation = velocity.angle()

func _stop_moving() -> void: 
	has_hit = true
	velocity = Vector2.ZERO
	despawn_timer = TIME_TO_DESPAWN

func _on_body_entered(body: Node2D) -> void: 
	_stop_moving()
	if body.is_in_group("Enemy"):
		hitbox_component.set_collision_mask_value(3, false)
		collision.set_collision_layer_value(3, false)
		self.reparent.call_deferred(body)
		weapon.add_dash_charge()
