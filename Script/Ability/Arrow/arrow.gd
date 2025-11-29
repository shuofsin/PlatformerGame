extends Node2D
class_name Arrow

@export var hitbox_component: HitboxComponent
@export var collision: Area2D
@export var arrow_texture: AbilityTexture
var weapon: Weapon

var _gravity: float = 9.8
@export var mass: float = 0.25
var velocity: Vector2 = Vector2.ZERO
var gravity_vector: Vector2 = Vector2.DOWN
@export var initial_speed: float = 600

var has_hit: bool = false
@export var time_to_despawn: float = 2
var despawn_timer: float = 0
const TIME_TO_FADE: float = 1

## Set continous collisions
func _ready() -> void: 
	z_index = -1
	arrow_texture.play_animation("RESET")
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
	_extra_process()

func _physics_process(delta: float) -> void: 	
	if (!has_hit): 
		velocity += gravity_vector * _gravity * mass
		position += velocity * delta
		rotation = velocity.angle()
	_extra_physics_process()

func _stop_moving() -> void: 
	has_hit = true
	velocity = Vector2.ZERO
	despawn_timer = time_to_despawn

func _on_body_entered(body: Node2D) -> void: 
	_stop_moving()
	hitbox_component.set_collision_mask_value(3, false)
	collision.set_collision_mask_value(3, false)
	collision.set_collision_mask_value(1, false)
	if body.is_in_group("Enemy"):
		self.reparent.call_deferred(body)
		weapon.add_dash_charge()

func _extra_process() -> void: 
	pass

func _extra_physics_process() -> void: 
	pass
