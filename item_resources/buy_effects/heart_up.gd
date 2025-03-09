class_name HeartUp extends OnBuy

func trigger() -> void:
	PlayerData.max_health += 2
	PlayerData.change_health(2)
