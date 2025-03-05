extends CanvasLayer

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var generation: Node = $"../Generation"

func _ready() -> void:
	update_health_bar()
	PlayerData.health_changed.connect(update_health_bar)

func _process(_delta: float) -> void:
	$statbar/coincount.text = str(PlayerData.coins)
	
	if player.has_key:
		$statbar/key.modulate = "ffffff"
	else:
		$statbar/key.modulate = "2a2a2abe"


func update_health_bar():
	var max_hearts = PlayerData.max_health / 2
	var health = PlayerData.health
	var heart_container = $HealthBar
	var heart_scene = preload("res://scenes/ui_heart.tscn")

	for child in heart_container.get_children():
		heart_container.remove_child(child)
		child.queue_free()

	for i in range(max_hearts):
		var heart = heart_scene.instantiate()
		heart.name = "Heart " + str(i + 1)
		heart.position = Vector2(i * (40+10), 0)
		heart.position.x += 25
		heart.position.y += 20
		heart_container.add_child(heart)
	$HealthBar.size.x = (max_hearts * 40) + (max_hearts * 10)

	for i in range(max_hearts):
		var heart = heart_container.get_child(i)
		var heart_health = clamp(health - (i * 2), 0, 2)
		heart.frame = heart_health
