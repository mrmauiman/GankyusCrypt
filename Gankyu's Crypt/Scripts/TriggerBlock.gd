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
	$Timer.start(0.5)
	camera.set_offset(global_position)
	GlobalVariables.paused = true
	visible = false
	print("done")


func _on_Timer_timeout():
	camera.set_offset(Vector2.ZERO, true)
	GlobalVariables.paused = false
	queue_free()
