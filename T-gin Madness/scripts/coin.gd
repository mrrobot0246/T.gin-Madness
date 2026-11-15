extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("play_coin"):
			body.play_coin()
		GameState.add_coin()
		queue_free()
