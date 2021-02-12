extends Control

var game = preload("res://Scenes/TestRoom.tscn")
var flip_back = false

func _ready():
	if GlobalVariables.paused:
		$menu_page/Play.text = "Resume Adventure"
		$MenuMusic.queue_free()
	$options_page/MusicSlider.value = GlobalVariables.music_volume
	$options_page/MusicValue.text = str(GlobalVariables.music_volume)
	$options_page/SFXSlider.value = GlobalVariables.sfx_volume
	$options_page/SFXValue.text = str(GlobalVariables.sfx_volume)

func _on_Play_pressed():
	if GlobalVariables.paused:
		GlobalVariables.paused = false
		queue_free()
		return
	get_tree().change_scene_to(game)

func _on_Options_pressed():
	$menu_page.visible = false
	flip_back = false
	$Book.play("turn_page")

func _on_Quit_pressed():
	get_tree().quit()

func add_outline(node):
	var font = node.get("custom_fonts/font")
	font.outline_size = 1

func remove_outline(node):
	var font = node.get("custom_fonts/font")
	font.outline_size = 0


func _on_Play_mouse_entered():
	add_outline($menu_page/Play)


func _on_Play_mouse_exited():
	remove_outline($menu_page/Play)


func _on_Options_mouse_entered():
	add_outline($menu_page/Options)


func _on_Options_mouse_exited():
	remove_outline($menu_page/Options)


func _on_Quit_mouse_entered():
	add_outline($menu_page/Quit)


func _on_Quit_mouse_exited():
	remove_outline($menu_page/Quit)


func _on_HSlider_value_changed(value):
	GlobalVariables.music_volume = value
	$options_page/MusicValue.text = str(value)


func _on_SFXSlider_value_changed(value):
	GlobalVariables.sfx_volume = value
	$options_page/SFXValue.text = str(value)


func _on_Return_pressed():
	$options_page.visible = false
	flip_back = true
	$Book.play("turn_back")


func _on_Return_mouse_entered():
	add_outline($options_page/Return)


func _on_Return_mouse_exited():
	remove_outline($options_page/Return)


func _on_Book_animation_finished():
	if flip_back:
		remove_outline($menu_page/Options)
		$menu_page.visible = true
	else:
		remove_outline($options_page/Return)
		$options_page.visible = true
