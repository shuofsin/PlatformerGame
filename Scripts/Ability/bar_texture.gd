extends Sprite2D
class_name BarTexture

var initial_percent: float = 0

func _ready() -> void:
	region_enabled = true
	set_value(initial_percent / 100)
	
func set_value(value: float) -> void: 
	region_rect = Rect2(0, 0, texture.get_width() * value, texture.get_height())
