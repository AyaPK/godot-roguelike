extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("Player")[0]

var hp: int = 3
var damage: int = 1
var attack_chance: float = 0.5

func move() -> void:
	print("anana")
	if randf() < 0.2:
		return
	print("enenene")
	var dir: Vector2 = Vector2.ZERO
	var can_move: bool
	
	while !can_move:
		dir = get_random_direction()
		
		var space_rid = get_world_2d().space
		var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position+Vector2(40, 40) * dir)
		var result = space_state.intersect_ray(query)
		
		if !result and position + 40 * dir != player.position:
			can_move = true
	position += 40 * dir

func get_random_direction() -> Vector2:
	var ran : int = randi_range(0, 3)
	match ran:
		0:
			return Vector2.UP
		1:
			return Vector2.DOWN
		2:
			return Vector2.RIGHT
		3:
			return Vector2.LEFT
	return Vector2.ZERO
