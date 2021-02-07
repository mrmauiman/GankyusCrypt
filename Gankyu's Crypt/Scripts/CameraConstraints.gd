extends Area2D

export (NodePath) var camera_path
var camera

export (Dictionary) var constraints = {
	"left": 0,
	"right": 0,
	"top": 0,
	"bottom": 0
}

export (bool) var smooth = true


func _ready():
	camera = get_node(camera_path)


func _on_CameraConstraints_body_entered(body):
	if body.is_in_group("player"):
		camera.set_constraints(constraints, smooth)
