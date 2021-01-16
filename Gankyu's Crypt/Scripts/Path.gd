extends Sprite

signal TurnOffCliffs
signal TurnOnCliffs

func change_end_collision(bit):
	$End/CollisionShape2D.set_deferred("disabled", bit)
#	$End.set_collision_layer_bit(0, not bit)
#	$End.set_collision_mask_bit(0, not bit)

func _on_Area2D_body_entered(body):
	if (body.is_in_group("player")):
		emit_signal("TurnOffCliffs")
	if (body.is_in_group("cliff")):
		change_end_collision(true)


func _on_Area2D_body_exited(body):
	if (body.is_in_group("player")):
		emit_signal("TurnOnCliffs")
	if (body.is_in_group("cliff")):
		change_end_collision(false)


func _on_Area2D_area_entered(area):
	if (area.is_in_group("valid_space")):
		change_end_collision(true)


func _on_Area2D_area_exited(area):
	if (area.is_in_group("valid_space")):
		change_end_collision(false)
