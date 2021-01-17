extends Node2D

var player = null
var goal
var speed = 0
var going_out = true
var return_speed = 0
var wait = false

const throw_dist = 100
const move_speed = 200
const min_speed = 15
const return_growth = 200

func wait():
	visible = false
	wait = true

func set_goal(dir, start = player.position):
	visible = true
	wait = false
	position = start
	goal = position + (dir * throw_dist)
	going_out = true

func return_to_player():
	visible = true
	wait = false
	going_out = false
	return_speed = speed

func _process(delta):
	if (Input.is_action_just_pressed("boomerang")):
		return_to_player()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (not wait):
		var velocity
		if going_out:
			var diff = goal - position
			var interpolator = diff.length() / throw_dist
			speed = lerp(0, move_speed, interpolator)
			if speed < min_speed:
				return_to_player()
			velocity = diff.normalized() * speed * delta
		else:
			var diff = player.position - position
			return_speed += return_growth * delta
			velocity = diff.normalized() * return_speed * delta
		position += velocity


func _on_Hitbox_body_entered(body):
	if not body.is_in_group("player"):
		return_to_player()
	elif not going_out:
		player.has_boomerang = true
		queue_free()
