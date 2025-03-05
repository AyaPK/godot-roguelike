extends Node2D

var inside_width: int = 7
var inside_height: int = 7

@onready var Generation: Node

func north() -> void:
	$north_door.visible = true
	$north_wall.queue_free()

func south() -> void:
	$south_door.visible = true
	$south_wall.queue_free()

func east() -> void:
	$east_door.visible = true
	$east_wall.queue_free()

func west() -> void:
	$west_door.visible = true
	$west_wall.queue_free()
