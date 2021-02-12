extends KinematicBody2D

export(PackedScene) var GameOver

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
var has_boomerang = false;

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
export(NodePath) var GUI_path
var GUI


# Chests
var chest = null

# resources
var boomerang_scene = preload("res://Scenes/Boomerang.tscn")

# constants
const max_health = 100
const potion_potancy = 20

# stats
var keys = 0
var health = 100
var boss_key_1 = false
var boss_key_2 = false

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
	if (Input.is_action_just_pressed("down") and not directions.DOWN in input_stack):
		input_stack.push_back(directions.DOWN)
	if (Input.is_action_just_released("down")):
		input_stack.erase(directions.DOWN)
	
	# Up
	if (Input.is_action_just_pressed("up") and not directions.UP in input_stack):
		input_stack.push_back(directions.UP)
	if (Input.is_action_just_released("up")):
		input_stack.erase(directions.UP)
	
	# Right
	if (Input.is_action_just_pressed("right") and not directions.RIGHT in input_stack):
		input_stack.push_back(directions.RIGHT)
	if (Input.is_action_just_released("right")):
		input_stack.erase(directions.RIGHT)
	
	# Left
	if (Input.is_action_just_pressed("left") and not directions.LEFT in input_stack):
		input_stack.push_back(directions.LEFT)
	if (Input.is_action_just_released("left")):
		input_stack.erase(directions.LEFT)
	
	# Check Sword and Boomerang only if player is in the move state
	if (state == states.MOVE):
		# Attack
		if (Input.is_action_just_pressed("sword")):
			if (chest != null and not chest.opened):
				chest.open()
			else:
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
	if (GlobalVariables.DEBUG_MODE):
		has_boomerang = true
	animated_sprite = get_node("AnimatedSprite")
	animation_player = get_node("AnimationPlayer")
	sword_shape = get_node("SwordHitbox/CollisionShape2D")
	set_animation("idle")
	GUI = get_node(GUI_path)
	GUI.SetHealth(health/max_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_inputs()

func _physics_process(delta):
	if GlobalVariables.paused:
		return
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

func recieve(var item):
	match(item):
		0: #KEY
			keys += 1
			GUI.GetKey()
		1: #BOSS_KEY_1
			boss_key_1 = true
			GUI.GetBossKey1()
		2: #BOSS_KEY_2
			boss_key_2 = true
			GUI.GetBossKey2()
		3: #BOSS_KEY
			boss_key_1 = true
			boss_key_2 = true
			GUI.GetBossKey()
		4: #POTION
			health += potion_potancy
			GUI.SetHealth(float(health)/max_health)
		5: #BOOMERANG
			has_boomerang = true
			GUI.GetBoomerang()

func take_damage(amount):
	health -= amount
	var percentage = float(health)/max_health
	GUI.SetHealth(percentage)
	if health <= 0:
		animated_sprite.play("death")
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		state = null
		get_tree().get_root().get_node("TestRoom/CanvasLayer").add_child(GameOver.instance())

func take_knockback(amount):
	var vec = movement_map[direction] * -amount
	if (not test_move(transform, vec)):
		position += vec
	else:
		while (test_move(transform, vec)):
			vec -= vec.normalized()
			if (test_move(transform, Vector2.ZERO)):
				vec = Vector2.ZERO
				break
		position += vec

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("enemy_hitbox"):
		if area.is_in_group("blockable") and state != states.ATTACK:
			var diff = area.global_position - global_position
			var temp_dir
			if diff.x > diff.y:
				if diff.x > 0:
					temp_dir = directions.RIGHT
				else:
					temp_dir = directions.LEFT
			else:
				if diff.y > 0:
					temp_dir = directions.DOWN
				else:
					temp_dir = directions.UP
			if direction == temp_dir:
				area.get_parent().queue_free()
				return
		take_damage(area.damage)
		take_knockback(area.knockback)
		if area.is_in_group("projectile"):
			area.get_parent().queue_free()
