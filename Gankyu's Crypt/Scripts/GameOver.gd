extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("FadeIn")



func _on_Button_pressed():
	print("pressed")
	get_tree().reload_current_scene()

func remove_cover():
	$ColorRect2.queue_free()
