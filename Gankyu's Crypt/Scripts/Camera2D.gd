extends Camera2D


func set_offset(value, relative = false):
	if not relative:
		value = to_local(value)
	position = value

func zoomout():
	zoom = Vector2(1.5, 1.5)

func zoomin():
	zoom = Vector2(1, 1)
