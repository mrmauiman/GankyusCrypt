extends AnimatedSprite

func display(var enable):
	visible = enable
	$Area2D/CollisionShape2D.set_deferred("disabled", not enable)
