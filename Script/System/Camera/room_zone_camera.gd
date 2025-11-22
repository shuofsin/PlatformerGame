extends Camera2D

var overlapping_zones: Array = []
var active_zone: Area2D

var follow_player: bool = false

func _process(_delta: float) -> void:
	if !Global.player:
		return 
	
	if overlapping_zones.is_empty() or (overlapping_zones.size() == 1 and active_zone == overlapping_zones[0]):
		return
	
	var new_zone = get_closest_zone()
	if new_zone != active_zone:
		active_zone = new_zone
		apply_zone_settings()

func _physics_process(_delta: float) -> void:
	if follow_player and Global.player: 
		global_position = Global.player.global_position

func get_closest_zone() -> Area2D:
	var closest_zone: Area2D = null
	var closest_distance: float = INF
	var player_position: Vector2 = Global.player.global_position
	
	for zone in overlapping_zones:
		var zone_shape: CollisionShape2D = zone.collision_shape
		var collision_margin: float = 0.1
		var zone_shape_position: Vector2 = zone_shape.global_position
		var zone_shape_extents: Vector2 = zone_shape.shape.extents
		var shape_sides: Array[Vector2] = [
			Vector2(zone_shape_position.x - zone_shape_extents.x + collision_margin, player_position.y),
			Vector2(zone_shape_position.x + zone_shape_extents.x - collision_margin, player_position.y),
			Vector2(player_position.x, zone_shape_position.y - zone_shape_extents.y + collision_margin),
			Vector2(player_position.x, zone_shape_position.y + zone_shape_extents.y - collision_margin)
		]
		var closest_distance_shapeside: float = INF
		for collision_side in shape_sides: 
			var collision_distance: float = player_position.distance_to(collision_side)
			if collision_distance < closest_distance_shapeside:
				closest_distance_shapeside = collision_distance
		
		if closest_distance_shapeside < closest_distance:
			closest_distance = closest_distance_shapeside
			closest_zone = zone
	
	return closest_zone

func apply_zone_settings(): 
	zoom = active_zone.zoom
	
	follow_player = active_zone.follow_player
	if !active_zone.follow_player:
		global_position = active_zone.fixed_position
	
	if active_zone.limit_camera: 
		limit_enabled = true
		limit_left = active_zone.limit_left
		limit_right = active_zone.limit_right
		limit_top = active_zone.limit_top
		limit_bottom = active_zone.limit_bottom
	else:
		limit_enabled = false
	
	
