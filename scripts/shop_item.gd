@tool
extends Area2D

@export var item_sprite: Texture2D :
	set(_v):
		item_sprite = _v
		set_sprite()

@export var price: int = 100 :
	set(_v):
		price = _v
		set_price()

func _ready() -> void:
	$sprite.texture = item_sprite
	$cost_label.text = str(price)

func set_sprite() -> void:
	print("eeee")
	$sprite.texture = item_sprite

func set_price() -> void:
	$cost_label.text = str(price)
