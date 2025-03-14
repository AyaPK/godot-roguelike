extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("Player")[0]

var DEATH_EXPLOSION = preload("res://scenes/explosion.tscn")

var hp: int
var damage: int
var attack_chance: float

func _ready() -> void:
	hp = 3 + PlayerData.level
	damage = 2 + floori(PlayerData.level/2.0)
	attack_chance = randf_range(0.2, 1)

func move() -> void:
	if randf() < 0.5:
		return
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

func take_damage(damage_taken: int) -> void:
	hp -= damage_taken
	$AnimationPlayer.play("hit")
	if randf() > attack_chance:
		var damage_dealt: int = damage - PlayerData.def
		if damage_dealt < 0:
			damage_dealt = 0
		player.take_damage(damage_dealt)
	if hp <= 0 and PlayerData.health > 0:
		_on_kill()

func _on_kill() -> void:
	var _particle = DEATH_EXPLOSION.instantiate()
	_particle.global_position = global_position
	_particle.emitting = true
	PlayerData.coins += 1
	get_tree().current_scene.add_child(_particle)
	queue_free()
