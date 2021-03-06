extends Node2D

const VIEWPORT_WIDTH = 432
const VIEWPORT_HEIGHT = 240

export(float) var wait_time = 1.1

export(Array, NodePath) var turnable_paths
var turnables = []

export(PackedScene) var PlayerZone = preload("res://Scenes/PlayerZone.tscn")
var zones = []

export(NodePath) var camera_path
var camera

var active = false

var threshold = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	for path in turnable_paths:
		var node = get_node(path)
		turnables.append(node)
		var zone = PlayerZone.instance()
		zone.position = to_local(node.global_position)
		add_child(zone)
		zones.append(zone)
	camera = get_node(camera_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activate():
	active = true
	var time = 0
	var camera_offset = null
	for turnable in turnables:
		var temp = turnable.turn()
		if (temp > time):
			time = temp
		# Camera
		if camera_offset == null:
			camera_offset = turnable.global_position
		else:
			camera_offset += turnable.global_position
	
	#camera.zoomout()
	camera_offset = camera_offset/len(turnables)
	camera.set_offset(camera_offset)
	$Timer.start(time * wait_time)
	$Sprite.frame += 1

func _on_Timer_timeout():
	if (active):
		$Sprite.frame -= 1
		active = false
		camera.set_offset(Vector2.ZERO, true)
		#camera.zoomin()

func player_in_zone():
	for zone in zones:
		if zone.inside:
			return true
	return false

func _on_CollisionBox_area_entered(area):
	if (area.is_in_group("hit_box")):
		if (not active and not player_in_zone()):
			activate()
