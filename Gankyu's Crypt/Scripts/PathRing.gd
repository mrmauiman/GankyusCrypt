extends Sprite

export(PackedScene) var turnable

export(bool) var up = false
export(bool) var left = false
export(bool) var right = false
export(bool) var down = false

var turnables = []

func add_path(direction):
	var node = turnable.instance()
	node.type = node.types.PATH
	node.start_direction = direction
	node.rotation_degrees = direction
	turnables.append(node)
	add_child(node)

# Called when the node enters the scene tree for the first time.
func _ready():
	if (up):
		add_path(180)
	if (left):
		add_path(90)
	if (right):
		add_path(-90)
	if (down):
		add_path(0)


func turn():
	var time = 0
	for node in turnables:
		var temp = node.turn()
		if temp > time:
			time = temp
	return time
