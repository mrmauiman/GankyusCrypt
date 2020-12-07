extends KinematicBody2D

# states
enum states {MOVE, ATTACK, THROW}
var state = states.MOVE

# movement
enum directions {UP, DOWN, LEFT, RIGHT}
var movement_map = {
	directions.UP: Vector2(0, -1),
	directions.DOWN: Vector2(0, 1),
	directions.RIGHT: Vector2(1, 0),
	directions.LEFT: Vector2(-1, 0)
}
var input_stack = []
var speed = 80

# boomerang
var has_boomerang = true;

# animation
var direction = directions.DOWN
var string_map = {
	directions.DOWN: "down",
	directions.UP: "up",
	directions.RIGHT: "right",
	directions.LEFT: "left"
}

# Nodes
var animated_sprite
var animation_player
var sword_shape

# resources
var boomerang_scene = preload("res://Scenes/Boomerang.tscn")

# new state is the state to change to
# calls any processes for the end of a state or the begining of a state and
# switches to new_state
func set_state(new_state):
	# end of state
	match(state):
		states.MOVE:
			pass
		states.ATTACK:
			set_animation("idle")
		states.THROW:
			set_animation("idle")
	
	# beginning of state
	match(new_state):
		states.MOVE:
			pass
		states.ATTACK:
			set_animation("attack")
		states.THROW:
			has_boomerang = false
			set_animation("throw")
			
	
	# change state
	state = new_state

# Checks the inputs and updates their corresponding variables
func get_inputs():
	# Down
	if (Input.is_action_just_pressed("down")):
		input_stack.push_back(directions.DOWN)
	if (Input.is_action_just_released("down")):
		input_stack.erase(directions.DOWN)
	
	# Up
	if (Input.is_action_just_pressed("up")):
		input_stack.push_back(directions.UP)
	if (Input.is_action_just_released("up")):
		input_stack.erase(directions.UP)
	
	# Right
	if (Input.is_action_just_pressed("right")):
		input_stack.push_back(directions.RIGHT)
	if (Input.is_action_just_released("right")):
		input_stack.erase(directions.RIGHT)
	
	# Left
	if (Input.is_action_just_pressed("left")):
		input_stack.push_back(directions.LEFT)
	if (Input.is_action_just_released("left")):
		input_stack.erase(directions.LEFT)
	
	# Check Sword and Boomerang only if player is in the move state
	if (state == states.MOVE):
		# Attack
		if (Input.is_action_just_pressed("sword")):
			set_state(states.ATTACK)
		# Boomerang
		if (Input.is_action_just_pressed("boomerang") && has_boomerang):
			set_state(states.THROW)

func set_animation(animation: String):
	animation_player.play(animation)
	set_animated_sprite(animation)

# if there is a value in input_stack move the player in that direction
func move_player():
	if (not input_stack.empty()):
		direction = input_stack.back()
		move_and_slide(movement_map[direction] * speed)
		# set animation
		set_animation("walk")
	else:
		# idle animation
		set_animation("idle")

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite = get_node("AnimatedSprite")
	animation_player = get_node("AnimationPlayer")
	sword_shape = get_node("SwordHitbox/CollisionShape2D")
	set_animation("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_inputs()

func _physics_process(delta):
	match(state):
		states.MOVE:
			move_player()
		states.ATTACK:
			pass
		states.THROW:
			pass

# AnimationPlayer Function Calls
func set_animated_sprite(animation: String):
	animated_sprite.animation = animation + "_" + string_map[direction]

# activate sword hitbox and position it
func activate_hitbox():
	sword_shape.disabled = false
	match(direction):
		directions.DOWN:
			sword_shape.shape.set_extents(Vector2(10, 5))
			sword_shape.position = Vector2(-2, 10)
		directions.UP:
			sword_shape.shape.set_extents(Vector2(10, 5))
			sword_shape.position = Vector2(2, -10)
		directions.RIGHT:
			sword_shape.shape.set_extents(Vector2(5, 10))
			sword_shape.position = Vector2(10, 2)
		directions.LEFT:
			sword_shape.shape.set_extents(Vector2(5, 10))
			sword_shape.position = Vector2(-10, 2)

# throw the boomerang
func throw_boomerang():
	var boomerang = boomerang_scene.instance()
	get_tree().root.add_child(boomerang)
	boomerang.player = self
	boomerang.set_goal(movement_map[direction])
	set_state(states.MOVE)
