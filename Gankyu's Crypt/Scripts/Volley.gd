extends Node2D

export(float) var spin_speed = 30
export(Vector2) var velocity = Vector2.DOWN * 50

func _physics_process(delta):
	if $HitBox.is_in_group("stunner"):
		rotation_degrees += rad2deg(spin_speed * delta)
	position += velocity * delta


func _on_HitBox_area_entered(area):
	if area.is_in_group("boomerang"):
		area.get_parent().return_to_player()
	if $HitBox.is_in_group("stunner"):
		if area.is_in_group("boomerang"):
			queue_free()
		elif area.is_in_group("hit_box"):
			velocity *= -1


func _on_HitBox_body_entered(body):
	queue_free()
