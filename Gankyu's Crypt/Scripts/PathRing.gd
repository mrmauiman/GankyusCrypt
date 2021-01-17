extends Sprite

export(PackedScene) var turnable

export(bool) var up = false
export(bool) var left = false
export(bool) var right = false
export(bool) var down = false

export(int) var type = 0

var turnables = []

func add_path(direction):
	var node = turnable.instance()
	var types = [node.types.PATH, node.types.WATER]
	node.type = types[type]
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
	if (type == 1):
		$DropOffs.rotation_degrees += 90
	return time

func fill_wings():
	for node in turnables:
		var path = node.get_node("TurnableWater/WaterPath")
		if not path.filled:
			path.add_water(false)

func drain_wings():
	for node in turnables:
		var path = node.get_node("TurnableWater/WaterPath")
		if path.filled:
			path.remove_water()

func fill():
	$AnimatedSprite.animation = "fill"
	fill_wings()

func drain():
	$AnimatedSprite.animation = "drain"
	dropoffs_on(false)
	drain_wings()

func dropoffs_on(visibility):
	if (not up):
			$DropOffs/Up.display(visibility)
	if (not left):
			$DropOffs/Left.display(visibility)
	if (not right):
			$DropOffs/Right.display(visibility)
	if (not down):
			$DropOffs/Down.display(visibility)

func _on_AnimatedSprite_animation_finished():
	if ($AnimatedSprite.animation == "fill"):
		$AnimatedSprite.animation = "idle"
		dropoffs_on(true)
