extends StaticBody2D
class_name Door 

@export var death_trigger_node: Node2D

func _process(_delta: float) -> void:
	if !death_trigger_node:
		var tween = create_tween()
		tween.finished.connect(queue_free)
		tween.tween_property(self, "modulate:a", 0.0, 1)
