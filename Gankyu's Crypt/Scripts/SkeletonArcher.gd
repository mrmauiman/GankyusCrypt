extends "res://Scripts/Enemy.gd"

export(int) var change_direction_chance = 5
export(int) var stop_chance = 10
export(float) var random_check_time = 1
export(float) var roam_speed = 50
export(float) var chase_speed = 70

onready var sprite = get_node("AnimatedSprite")
const arrow_resource = preload("res://Scenes/Arrow.tscn")

var roam_timer: float = 0
var shot_timer: float = 0
const shoot_time = 1.2

var moving = false
const chase_threshold = 4
const ray_length = 3 * 16 # 3 tiles
const arrow_speed = 250

var not_fired = true

var player

# Occurs on creation
func _ready():
	._ready()
	change_direction()

# Overload end spawning
func end_spawning():
	.end_spawning()
	$AgroRange/CollisionShape2D.set_deferred("disabled", false)

# Overload start spawning
func start_spawning():
	.start_spawning()
	$AgroRange/CollisionShape2D.set_deferred("disabled", true)

# Logic for roam state
func roam(delta):
	# check if should change direction
	roam_timer += delta
	if roam_timer > random_check_time:
		roam_timer = 0
		var roll = rng.randi_range(1, change_direction_chance)
		if roll == 1:
			change_direction()
		# check if should stop or start moving
		roll = rng.randi_range(1, stop_chance)
		if roll == 1:
			moving = not moving
	
	if moving:
		# handle movement
		velocity = direction_vectors[direction] * roam_speed
		if (test_move(transform, velocity * delta)):
			change_direction()
			velocity = direction_vectors[direction] * roam_speed
		# animation
		sprite.play("walk_" + direction_strings[direction])
	else:
		# handle standing still
		velocity = Vector2.ZERO
		# animation
		sprite.play("idle_" + direction_strings[direction])

# logic for agro state
func agro(delta):
	if (sprite.animation == "attack_" + direction_strings[direction]):
		velocity = Vector2.ZERO
		if sprite.frame > 3 and not_fired:
			#fire arrow
			not_fired = false
			var arrow = arrow_resource.instance()
			arrow.velocity = direction_vectors[direction] * arrow_speed
			arrow.rotation_degrees = direction_angles[direction]
			arrow.creator = self
			get_tree().get_root().call_deferred("add_child", arrow)
			arrow.global_position = global_position
	else:
		# Move Towards fire position
		var difference = player.global_position - global_position
		if min(abs(difference.x), abs(difference.y)) > 4:
			if abs(difference.x) > abs(difference.y):
				var diff = difference.y
				velocity = Vector2(0, diff).normalized() * chase_speed
				if abs(diff) < chase_threshold or test_move(transform, velocity * delta):
					velocity = Vector2(difference.x, 0).normalized() * chase_speed
			else:
				var diff = difference.x
				velocity = Vector2(diff, 0).normalized() * chase_speed
				if abs(diff) < chase_threshold or test_move(transform, velocity * delta):
					velocity = Vector2(0, difference.y).normalized() * chase_speed
		else:
			velocity = Vector2.ZERO
			if abs(difference.x) > abs(difference.y):
				if sign(difference.x) == 1:
					change_direction(directions.RIGHT)
				else:
					change_direction(directions.LEFT)
			else:
				if sign(difference.y) == 1:
					change_direction(directions.DOWN)
				else:
					change_direction(directions.UP)
			shot_timer += delta
			if shot_timer > shoot_time:
				sprite.play("attack_" + direction_strings[direction])
				shot_timer = 0
		
		if sprite.animation != "attack_" + direction_strings[direction]:
			if velocity == Vector2.ZERO:
				sprite.play("idle_" + direction_strings[direction])
			else:
				# Animation
				if velocity.x > 0:
					change_direction(directions.RIGHT)
				elif velocity.x < 0:
					change_direction(directions.LEFT)
				elif velocity.y > 0:
					change_direction(directions.DOWN)
				else:
					change_direction(directions.UP)
				sprite.play("walk_" + direction_strings[direction])


func _on_PlayerDetection_area_entered(area):
	if area.is_in_group("hurtbox"):
		if state != states.AGRO:
			set_state(states.AGRO)
		sprite.play("attack_" + direction_strings[direction])


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "attack_" + direction_strings[direction]:
		sprite.play("idle_" + direction_strings[direction])
		not_fired = true


func _on_AgroRange_body_entered(body):
	if body.is_in_group("player"):
		player = body
		set_state(states.AGRO)


func _on_AgroRange_body_exited(body):
	if body.is_in_group("player"):
		player = null
		set_state(states.ROAM)


func _on_HurtBox_area_entered(area):
	if area.is_in_group("hit_box"):
		if area.is_in_group("boomerang"):
			area.get_parent().return_to_player()
		take_damage(area.damage)
		knockback(area.knockback)
		start_invincibility()
