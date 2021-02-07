extends Button

var game = preload("res://Scenes/TestRoom.tscn")

func _on_Play_pressed():
	get_tree().change_scene_to(game)
