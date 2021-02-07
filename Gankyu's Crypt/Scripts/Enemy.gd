extends KinematicBody2D

onready var SpawnCloud = load("res://Scenes/SpawnCloud.tscn")

enum directions {UP, LEFT, RIGHT, DOWN}
var direction_vectors = {
	directions.UP: Vector2.UP,
	directions.LEFT: Vector2.LEFT,
	directions.RIGHT: Vector2.RIGHT,
	directions.DOWN: Vector2.DOWN
}
var direction_angles = {
	directions.UP: 180,
	directions.LEFT: 90,
	directions.RIGHT: 270,
	directions.DOWN: 0
}
var direction_strings = {
	directions.UP: "up",
	directions.LEFT: "left",
	directions.RIGHT: "right",
	directions.DOWN: "down"
}

var direction = directions.DOWN

enum states {SPAWNING, ROAM, AGRO}
var state = null
var invincibility_timer = 0

var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()

export(int) var health = 10

var rays = []
const WALL_CHECK_LENGTH = 12

func start_invincibility():
	invincibility_timer = 0.5
	$AnimationPlayer.play("invincibility")

func knockback(amount):
	if (invincibility_timer <= 0):
		var vec = direction_vectors[direction] * -amount
		if (not test_move(transform, vec)):
			position += vec
		else:
			while (test_move(transform, vec)):
				vec -= vec.normalized()
				if (test_move(transform, Vector2.ZERO)):
					vec = Vector2.ZERO
					break
			position += vec

func take_damage(amount):
	if (invincibility_timer <= 0):
		health -= amount
		if health <= 0:
			queue_free()

func change_direction(dir = null):
	if dir != null:
		direction = dir
		return
	var dirs = []
	for i in range(4):
		if i != direction:
			if rays[i].get_collider() == null:
				dirs.append(i)
	if (len(dirs) > 0):
		direction = dirs[rng.randi_range(0, len(dirs)-1)]

func end_spawning():
	$AnimatedSprite.visible = true

func end_roam():
	pass

func end_agro():
	pass

func start_spawning():
	create_cloud()

func start_roam():
	pass

func start_agro():
	pass

func create_cloud():
	var cloud = SpawnCloud.instance()
	cloud.roam = states.ROAM
	call_deferred("add_child", cloud)
	cloud.position = Vector2.ZERO
	$AnimatedSprite.visible = false

# changes state to new_state and runs code for beginnning and end of a state
func set_state(var new_state: int) -> void:
	# End of State
	match(state):
		states.SPAWNING:
			end_spawning()
		states.ROAM:
			end_roam()
		states.AGRO:
			end_agro()
	state = new_state
	# Beginning of State
	match(state):
		states.SPAWNING:
			start_spawning()
		states.ROAM:
			start_roam()
		states.AGRO:
			start_agro()

# logic for roaming overload in children
func roam(delta):
	pass

# logic for agro overload in chilren
func agro(delta):
	pass

# Occurs on creation
func _ready():
	set_state(states.SPAWNING)
	rng.randomize()
	for i in range(4):
		var ray = RayCast2D.new()
		ray.cast_to = direction_vectors[i] * WALL_CHECK_LENGTH
		add_child(ray)
		rays.append(ray)

# happens every physics frame
func _physics_process(delta):
	if GlobalVariables.paused:
		return
	invincibility_timer -= delta
	
	# Only run code for the current state
	match(state):
		states.ROAM:
			roam(delta)
		states.AGRO:
			agro(delta)
	
	# apply movements
	move_and_slide(velocity)
