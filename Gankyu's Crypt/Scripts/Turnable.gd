extends Node2D

enum types {PATH, WATER, LAUNCHER}
export(types) var type

export(Array, PackedScene) var scenes

export(float) var turn_speed = 0.5  # this is how many seconds it takes to turn
export(int) var start_direction = 0 

var goal
var threshold = 5  # goal and threshold are in degrees

# Called when the node enters the scene tree for the first time.
func _ready():
	goal = start_direction
	add_child(scenes[type].instance())

func _physics_process(delta):
	if (abs(goal - rotation_degrees) > threshold):
		rotation_degrees += 90 * (delta/turn_speed)
	else:
		rotation_degrees = goal

# turns this item 90 degrees and returns how long it will take
func turn():
	goal += 90
	return turn_speed
