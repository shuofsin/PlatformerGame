extends Area2D
class_name RoomZoneArea

@export var zoom: Vector2 = Vector2.ONE

@export var follow_player: bool = false
@export var camera_position_node: Node2D
var fixed_position: Vector2 = Vector2.ZERO

@export var limit_camera: bool = false
@export var limit_left: float = -10000
@export var limit_right: float = -10000
@export var limit_top: float = -10000
@export var limit_bottom: float = -10000

var collision_shape: CollisionShape2D
var camera_node: Camera2D

func _ready() -> void:
	collision_shape = get_child(0)
	monitorable = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)
	
	if !camera_position_node: 
		fixed_position = collision_shape.global_position
	else:
		fixed_position = camera_position_node.global_position
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if !camera_node:
			camera_node = get_tree().get_first_node_in_group("Camera")
		camera_node.overlapping_zones.append(self)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if !camera_node: 
			camera_node = get_tree().get_first_node_in_group("Camera")
		camera_node.overlapping_zones.erase(self)
