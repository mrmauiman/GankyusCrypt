extends Sprite

var boomerang = null
onready var state_machine = $AnimationTree.get("parameters/playback")

func _on_Area2D_area_entered(area):
	if area.is_in_group("boomerang"):
		boomerang = area.get_parent()
		if boomerang.going_out:
			boomerang.wait()
			state_machine.travel("shoot")

func shoot():
	if boomerang.going_out:
		boomerang.set_goal(Vector2(0, 1).rotated(deg2rad(get_parent().rotation_degrees)), to_global(position + Vector2(0, 6)))
	boomerang = null
