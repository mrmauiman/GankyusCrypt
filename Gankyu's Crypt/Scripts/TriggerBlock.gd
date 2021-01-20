extends Sprite

enum types {PUZZLE, COMBAT}
export(types) var type

export(NodePath) var camera_path
var camera
var camera_parent

var type_to_frame_map = {types.PUZZLE: 2, types.COMBAT: 1}

func _ready():
	frame = type_to_frame_map[type]
	camera = get_node(camera_path)

func open():
	$Timer.start(0.5)
	camera_parent = camera.get_parent()
	camera_parent.remove_child(camera)
	camera.position = to_local(camera_parent.global_position)
	add_child(camera)
	camera.position = Vector2.ZERO
	visible = false
	print("done")


func _on_Timer_timeout():
	remove_child(camera)
	camera.position = camera_parent.to_local(global_position)
	camera_parent.add_child(camera)
	camera.position = Vector2.ZERO
	queue_free()
