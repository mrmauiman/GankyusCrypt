extends Node

onready var player = get_node("Player")
const CLIFF_COLLISION_BIT = 2
var num_off = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for path in get_tree().get_nodes_in_group("Path"):
		path.connect("TurnOffCliffs", self, "turn_off_cliffs")
		path.connect("TurnOnCliffs", self, "turn_on_cliffs")

func turn_off_cliffs():
	print("turnoff")
	player.set_collision_layer_bit(CLIFF_COLLISION_BIT, false)
	player.set_collision_mask_bit(CLIFF_COLLISION_BIT, false)
	num_off += 1

func turn_on_cliffs():
	num_off -= 1
	if (num_off == 0):
		print("turnon")
		player.set_collision_layer_bit(CLIFF_COLLISION_BIT, true)
		player.set_collision_mask_bit(CLIFF_COLLISION_BIT, true)
