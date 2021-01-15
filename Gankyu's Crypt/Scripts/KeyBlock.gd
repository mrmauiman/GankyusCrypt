extends Sprite

func _on_Area2D_body_entered(body):
	if (body.is_in_group("player")):
		if (body.keys > 0):
			body.keys -= 1
			queue_free()
