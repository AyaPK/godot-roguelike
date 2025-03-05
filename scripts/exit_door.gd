extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_key:
			PlayerData.level += 1
			PlayerData.map_seed += randi_range(1, 6969)
			Sfx.door.play()
			get_tree().reload_current_scene()
