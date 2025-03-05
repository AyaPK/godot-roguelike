extends Node2D

@export var enemy_node : PackedScene
@export var coin_node : PackedScene
@export var heart_node : PackedScene
@export var key_node : PackedScene
@export var exit_door_node : PackedScene

@onready var Generation: Node

var inside_width: int = 7
var inside_height: int = 7
var used_positions : Array

func _ready():
	for c in get_children():
		if c is TileMapLayer:
			c.modulate = PlayerData.random_modulate
	if Generation:
		generate_interior()

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

func spawn_node(node_scene: PackedScene, min_ins: int = 0, max_ins: int = 0) -> void:
	var number: int = 1
	if min_ins != 0 or max_ins != 0:
		number = randi_range(min_ins, max_ins)
	
	for i in range(number):
		var node_object = node_scene.instantiate()
		var pos: Vector2 = Vector2(40 * randi_range(2, inside_width - 1), 40 * randi_range(2, inside_height - 1))
		while pos in used_positions:
			pos = Vector2(40 * randi_range(2, inside_width - 1), 40 * randi_range(2, inside_height - 1))
		node_object.position = pos
		used_positions.append(position)
		add_child(node_object)
	if node_scene == enemy_node:
		get_tree().get_first_node_in_group("Enemy_Manager").check_enemies()

func generate_interior() -> void:
	if randf_range(0, 1) < Generation.enemy_spawn_chance:
		spawn_node(enemy_node, 1, Generation.max_enemies)
	if randf_range(0, 1) < Generation.coin_spawn_chance:
		spawn_node(coin_node, 1, Generation.max_coins)
	if randf_range(0, 1) < Generation.heart_spawn_chance:
		spawn_node(heart_node, 1, Generation.max_hearts)
