extends Node2D

export(NodePath) var door_path
var door

func _ready():
	door = get_node(door_path)

func _on_Area2D_area_entered(area):
	if (area.is_in_group("dropoff")):
		$AnimatedSprite.playing = true
		door.open()


func _on_Area2D_area_exited(area):
	if (area.is_in_group("dropoff")):
		$AnimatedSprite.playing = false
