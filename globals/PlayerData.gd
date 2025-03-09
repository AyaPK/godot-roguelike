extends Node

var max_health: int = 10
var health: int = max_health
var coins: int = 0
var level: int = 1
var map_seed: int = 9434

var random_modulate: Color

signal health_changed

func _ready() -> void:
	random_modulate = Color(randf_range(0,1), randf_range(0,1), randf_range(0,1))

func change_health(num: int) -> void:
	health += num
	health_changed.emit()
