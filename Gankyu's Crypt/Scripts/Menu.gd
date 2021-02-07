extends Control

var game = preload("res://Scenes/TestRoom.tscn")

func _on_Play_pressed():
	get_tree().change_scene_to(game)

func _on_Options_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit

func add_outline(node):
	var font = node.get("custom_fonts/font")
	font.outline_size = 1

func remove_outline(node):
	var font = node.get("custom_fonts/font")
	font.outline_size = 0


func _on_Play_mouse_entered():
	add_outline($Play)


func _on_Play_mouse_exited():
	remove_outline($Play)


func _on_Options_mouse_entered():
	add_outline($Options)


func _on_Options_mouse_exited():
	remove_outline($Options)


func _on_Quit_mouse_entered():
	add_outline($Quit)


func _on_Quit_mouse_exited():
	remove_outline($Quit)
