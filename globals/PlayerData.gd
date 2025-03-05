extends Node

var max_health: int = 4
var health: int = max_health
var coins: int = 0
var level: int = 1
var map_seed: int = 42069

signal health_changed

func change_health(num: int) -> void:
	health += num
	health_changed.emit()
