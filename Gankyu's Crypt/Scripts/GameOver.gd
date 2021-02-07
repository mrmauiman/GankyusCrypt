extends MarginContainer

onready var menu = load("res://Scenes/Menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("FadeIn")



func _on_Button_pressed():
	get_tree().change_scene_to(menu)

func remove_cover():
	$ColorRect2.queue_free()
