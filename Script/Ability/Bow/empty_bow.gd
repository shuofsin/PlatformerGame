extends Weapon

@onready var hand_right: Sprite2D = %HandRight
@onready var hand_left: Sprite2D = %HandLeft

func _extra_ready() -> void:
	is_active = false

func _extra_process(_delta: float) -> void:
	if !Global.player:
		return 
	
	hand_right.z_index = 1 if Global.player.body_sprite.flip_h else -1
	hand_left.z_index = -1 if Global.player.body_sprite.flip_h else 1
	if Global.player.state_machine.current_state.name.to_lower() == "walk":
		weapon_texture.play_animation("walk")
	else:
		weapon_texture.play_animation("idle")
