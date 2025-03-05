extends CanvasLayer

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var generation: Node = $"../Generation"
