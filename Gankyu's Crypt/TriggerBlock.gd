extends Sprite

enum types {PUZZLE, COMBAT}
export(types) var type

export(NodePath) var camera_path
var camera

var type_to_frame_map = {types.PUZZLE: 2, types.COMBAT: 1}

func _ready():
	frame = type_to_frame_map[type]
	camera = get_node(camera_path)


func open():
	$Timer.start(1)
	camera.position = camera.to_local(global_position)
	visible = false


func _on_Timer_timeout():
	camera.position = Vector2.ZERO
	queue_free()
