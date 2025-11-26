extends Node2D
class_name ItemPickup

@export var item_texture: AbilityTexture
@export var collision: Area2D
@export var itemName: String
@export var itemType: Global.ITEM_TYPE = Global.ITEM_TYPE.WEAPON
@export var label: Label
@export_multiline var label_text: String
@export var particle_effect: CPUParticles2D

var player_within_area: bool = false
var item_removed: bool = false

func _ready() -> void: 
	collision.body_entered.connect(_player_entered)
	collision.body_exited.connect(_player_exited)
	item_texture.play_animation("idle")
	label.text = label_text
	label.visible = false
	z_index = -2

func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("ui_accept"):
		return
	if !player_within_area:
		return
	if item_removed: 
		return
	if itemType == Global.ITEM_TYPE.WEAPON:
		Global.player.ability_manager.equip_weapon(itemName)
	if itemType == Global.ITEM_TYPE.DASH:
		Global.player.ability_manager.equip_dash(itemName)
		Global.player.can_dash = true
	_remove_item()

func _remove_item() -> void:
	item_texture.visible = false
	item_removed = true
	collision.body_entered.disconnect(_player_entered)

func _player_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		label.visible = true
		player_within_area = true

func _player_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		label.visible = false
		player_within_area = false
