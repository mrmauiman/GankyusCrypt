extends Label

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().get_node("TestRoom/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Keys: " + str(player.keys)
