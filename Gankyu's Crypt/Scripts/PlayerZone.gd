extends Area2D

var inside = false


func _on_PlayerZone_body_entered(body):
	if(body.is_in_group("player")):
		inside = true


func _on_PlayerZone_body_exited(body):
	if(body.is_in_group("player")):
		inside = false
