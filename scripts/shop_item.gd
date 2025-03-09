@tool
extends Area2D

@export var item_resource: item :
	set(_v):
		item_resource = _v
		item_sprite = _v.sprite
		set_sprite()
		price = _v.cost
		set_price()

var item_sprite: Texture2D
var price: int = 100

func _ready() -> void:
	$sprite.texture = item_sprite
	$cost_label.text = str(price)

func set_sprite() -> void:
	$sprite.texture = item_sprite

func set_price() -> void:
	$cost_label.text = str(price)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if PlayerData.coins >= item_resource.cost:
			PlayerData.coins -= item_resource.cost
			item_resource.on_buy.trigger()
			queue_free()
		else:
			print("Too poor!")
