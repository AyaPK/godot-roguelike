class_name Player extends CharacterBody2D

signal player_moved
signal player_hit

var has_key: bool = false

func _physics_process(_delta: float) -> void:
	player_input()

func player_input() -> void:
	if Input.is_action_just_pressed("move_right"):
		velocity = Vector2.RIGHT
		move(velocity)
	elif Input.is_action_just_pressed("move_left"):
		velocity = Vector2.LEFT
		move(velocity)
	elif Input.is_action_just_pressed("move_up"):
		velocity = Vector2.UP
		move(velocity)
	elif Input.is_action_just_pressed("move_down"):
		velocity = Vector2.DOWN
		move(velocity)
	elif Input.is_action_just_pressed("atk_up"):
		try_attack(Vector2.UP)
	elif Input.is_action_just_pressed("atk_down"):
		try_attack(Vector2.DOWN)
	elif Input.is_action_just_pressed("atk_left"):
		try_attack(Vector2.LEFT)
	elif Input.is_action_just_pressed("atk_right"):
		try_attack(Vector2.RIGHT)

func move(dir: Vector2) -> void:
	var space_rid = get_world_2d().space
	var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position+Vector2(40, 40) * dir)
	var result = space_state.intersect_ray(query)
	
	if result:
		if result.collider.is_in_group("walls"):
			return
	position += 40 * dir
	player_moved.emit()

func take_damage(damage_taken: int) -> void:
	PlayerData.change_health(-1)
	$AnimationPlayer.play("hit")
	if PlayerData.health <= 0:
		get_tree().reload_current_scene()
	player_hit.emit()

func try_attack(direction: Vector2) -> void:
	var space_rid = get_world_2d().space
	var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(48, 48) * direction)
	var result = space_state.intersect_ray(query)
	if result:
		if result.collider.is_in_group("Enemy"):
			result.collider.take_damage(1)
	else:
		player_moved.emit()
