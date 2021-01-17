extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	update_bitmask_region(Vector2(-31, -71), Vector2(168, 24))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
