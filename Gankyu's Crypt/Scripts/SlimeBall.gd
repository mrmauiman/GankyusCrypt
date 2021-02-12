extends Node2D

var velocity = Vector2.ZERO
var creator = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if GlobalVariables.paused:
		return
	position += velocity * delta


func _on_Area2D_body_entered(body):
	if not body.is_in_group("player") and body != creator:
		queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("hurtbox") and area.get_parent().is_in_group("player"):
		queue_free()
