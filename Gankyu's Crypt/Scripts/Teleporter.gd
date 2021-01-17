extends Sprite

export(bool) var on = false
export(NodePath) var link_path
var link
var stale = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if on:
		$AnimationPlayer.play("on")
	else:
		$AnimationPlayer.play("off")
	link = get_node(link_path)

func turn_on():
	on = true
	$AnimationPlayer.play("on")


func _on_Area2D_body_entered(body):
	if(body.is_in_group("player") and on and not stale):
		body.global_position = link.global_position
		link.turn_on()
		link.stale = true


func _on_Area2D_body_exited(body):
	if(body.is_in_group("player") and on):
		stale = false
