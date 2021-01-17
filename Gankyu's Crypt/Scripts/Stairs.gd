extends Sprite

export(NodePath) var link_path
var link
var stale = false

# Called when the node enters the scene tree for the first time.
func _ready():
	link = get_node(link_path)


func _on_Area2D_body_entered(body):
	if(body.is_in_group("player")and not stale):
		body.global_position = link.global_position
		link.stale = true


func _on_Area2D_body_exited(body):
	if(body.is_in_group("player")):
		stale = false
