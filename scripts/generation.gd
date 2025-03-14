class_name Generator extends Node

@onready var room_scene: PackedScene = load("res://scenes/room.tscn")
@onready var store_scene: PackedScene = load("res://scenes/store.tscn")

var min_size: int = 7
var max_size: int = 7
var min_rooms: int = 6
var max_rooms: int = 12
var map_width: int
var map_height: int
var rooms: int
var room_counter: int = 0
var rooms_instantiated = false
var first_room_pos: Vector2

var map: Array
var room_nodes: Array

var store_exists: bool = false

@export var enemy_spawn_chance: float = 0.2
@export var coin_spawn_chance: float = 0.1
@export var heart_spawn_chance: float = 0.1
@export var max_enemies: int = 3
@export var max_coins: int = 0
@export var max_hearts: int = 0

func _ready():
	rooms = randi_range(min_rooms, max_rooms)
	map_height = randi_range(min_size, max_size)
	map_width = randi_range(min_size, max_size)
	for x in range(map_width):
		map.append([])
		for y in range(map_height):
			map[x].append(false)
	seed(PlayerData.map_seed)
	generate()

func generate() -> void:
	check_room(3,3,0,Vector2.ZERO,true)
	instantiate_rooms()
	#preview()
	$"../Player".global_position = (first_room_pos * 600) + Vector2(160, 160)

func preview() -> void:
	var map_string = ""
	for y in range(map_height):
		for x in range(map_width):
			if map[x][y]:
				map_string += "|O|"
			else:
				map_string += "|X|"
		map_string += "\n"
	print(map_string)

func check_room(x: int,
				y: int,
				unmade: int,
				gen_dir: Vector2,
				first_room: bool = false) -> void:
	if room_counter >= rooms:
		return
	if x < 0 or x > map_width-1 or y < 0 or y > map_height-1:
		return
	if !first_room and unmade <= 0:
		return
	if map[x][y]:
		return
	if first_room:
		first_room_pos = Vector2(x, y)
	
	room_counter += 1
	map[x][y] = true
	
	var north: bool = randf() > (0.2 if gen_dir == Vector2.UP else 0.8)
	var south: bool = randf() > (0.2 if gen_dir == Vector2.DOWN else 0.8)
	var east: bool = randf() > (0.2 if gen_dir == Vector2.RIGHT else 0.8)
	var west: bool = randf() > (0.2 if gen_dir == Vector2.LEFT else 0.8)
	
	var max_remaining: int = rooms
	
	if north or first_room:
		check_room(x, y+1, max_remaining if first_room else unmade - 1, Vector2.UP if first_room else gen_dir)
	if south or first_room:
		check_room(x, y-1, max_remaining if first_room else unmade - 1, Vector2.DOWN if first_room else gen_dir)
	if east or first_room:
		check_room(x+1, y, max_remaining if first_room else unmade - 1, Vector2.RIGHT if first_room else gen_dir)
	if west or first_room:
		check_room(x-1, y, max_remaining if first_room else unmade - 1, Vector2.LEFT if first_room else gen_dir)

func instantiate_rooms() -> void:
	if rooms_instantiated:
		return
	rooms_instantiated = true
	
	for x in range(map_width):
		for y in range(map_height):
			if !map[x][y]:
				continue
			var room = room_scene.instantiate()
			var is_store = false
			
			if !store_exists and randf_range(0,1) < 0.1:
				room = store_scene.instantiate()
				store_exists = true
				is_store = true
			
			room.position = Vector2(x, y) * 600
			if y > 0 and map[x][y - 1]:
				room.north()
			if y < map_height - 1 and map[x][y + 1]:
				room.south()
			if x > 0 and map[x - 1][y]:
				room.west()
			if x < map_width - 1 and map[x + 1][y]:
				room.east()
			if first_room_pos != Vector2(x, y):
				room.Generation = self
			$"..".call_deferred("add_child", room)
			if !is_store:
				room_nodes.append(room)
	get_tree().create_timer(0.5)
	calculate_key_and_exit()

func calculate_key_and_exit() -> void:
	var max_dis : float = 0
	var room_a : Node2D = null
	var room_b : Node2D = null
	for a : Node2D in room_nodes:
		for b : Node2D in room_nodes:
			var dis : float = a.position.distance_to(b.position)
			if dis > max_dis:
				room_a = a
				room_b = b
				max_dis = dis
	room_a.spawn_node(room_a.key_node)
	room_b.spawn_node(room_b.exit_door_node)
