class_name store_room extends base_room

@export var shopkeep_node: PackedScene

var item_resources: Array[String] = [
	"res://item_resources/heart_up.tres",
	"res://item_resources/atk_up.tres",
	"res://item_resources/def_up.tres",
]

var items: Array

func _ready():
	print(PlayerData.map_seed)
	items = []
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

func spawn_node(_node_scene: PackedScene, _min_ins: int = 0, _max_ins: int = 0) -> void:
	pass

func generate_interior() -> void:
	$shop_item_1.item_resource = load(item_resources.pick_random())
	items.append($shop_item_1.item_resource)
	$shop_item_2.item_resource = load(item_resources.pick_random())
	while $shop_item_2.item_resource in items:
		$shop_item_2.item_resource = load(item_resources.pick_random())
