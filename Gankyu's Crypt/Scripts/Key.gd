extends Node2D

const KEY_CODE = 0

func _on_Area2D_area_entered(area):
	if (area.is_in_group("boomerang")):
		get_parent().remove_child(self)
		area.add_child(self)
		position = Vector2.ZERO


func _on_Area2D_body_entered(body):
	if (body.is_in_group("player")):
		body.recieve(KEY_CODE)
