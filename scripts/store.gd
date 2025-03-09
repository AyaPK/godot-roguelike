class_name store_room extends base_room

@export var shopkeep_node: PackedScene

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
	pass

func generate_interior() -> void:
	pass
