class_name Player extends CharacterBody2D

signal player_moved
signal player_hit

const WALK = preload("res://sfx/walk.wav")
const HURT = preload("res://sfx/Hurt.wav")
const SWORD_SLASH = preload("res://sfx/Sword_Slash.wav")
const EXPLOSION = preload("res://scenes/explosion.tscn")

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
		$AtkAnim.play("up")
	elif Input.is_action_just_pressed("atk_down"):
		try_attack(Vector2.DOWN)
		$AtkAnim.play("down")
	elif Input.is_action_just_pressed("atk_left"):
		try_attack(Vector2.LEFT)
		$AtkAnim.play("left")
	elif Input.is_action_just_pressed("atk_right"):
		try_attack(Vector2.RIGHT)
		$AtkAnim.play("right")

func move(dir: Vector2) -> void:
	var space_rid = get_world_2d().space
	var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position+Vector2(40, 40) * dir)
	var result = space_state.intersect_ray(query)
	
	if result:
		if result.collider.is_in_group("walls"):
			return
	$SFX.stream = WALK
	$SFX.play()
	position += 40 * dir
	player_moved.emit()

func take_damage(_damage_taken: int) -> void:
	PlayerData.change_health(-1)
	$AnimationPlayer.play("hit")
	if PlayerData.health <= 0:
		PlayerData.max_health = PlayerData.default_max_health
		PlayerData.health = PlayerData.max_health
		PlayerData.coins = 0
		PlayerData.level = 1
		PlayerData.atk = 1
		PlayerData.def = 1
		Sfx.death.play()
		visible = false
		process_mode = Node.PROCESS_MODE_DISABLED
		var _particle = EXPLOSION.instantiate()
		_particle.global_position = global_position
		_particle.emitting = true
		get_tree().current_scene.add_child(_particle)
		#get_tree().reload_current_scene()
	elif PlayerData.health > 0:
		$SFX.stream = HURT
		$SFX.play()
	player_hit.emit()

func try_attack(direction: Vector2) -> void:
	var space_rid = get_world_2d().space
	var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(48, 48) * direction)
	var result = space_state.intersect_ray(query)
	$SFX2.stream = SWORD_SLASH
	$SFX2.play()
	if result:
		if result.collider.is_in_group("Enemy"):
			result.collider.take_damage(PlayerData.atk)
	else:
		player_moved.emit()

func play_attack() -> void:
	$swing.frame = 0
	$swing.play()
	
