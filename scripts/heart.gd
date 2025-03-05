extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if PlayerData.health < PlayerData.max_health:
			PlayerData.change_health(2)
			queue_free()
