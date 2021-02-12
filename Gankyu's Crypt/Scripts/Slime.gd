extends "res://Scripts/Enemy.gd"

var counter = 0
const jump_chance = 3
const jump_speed = 50
const check_time = 0.5
onready var sprite = $AnimatedSprite
var random = RandomNumberGenerator.new()
var slimeballResource = preload("res://Scenes/SlimeBall.tscn")

var landed = false

func _ready():
	._ready()
	random.randomize()
	sprite.play("idle")

func attack():
	print("attack")
	for i in range(4):
		var ball = slimeballResource.instance()
		print(ball)
		ball.velocity = direction_vectors[i] * jump_speed * 2
		ball.creator = self
		get_tree().get_root().call_deferred("add_child", ball)
		ball.global_position = $SpawnLocation.global_position

func roam(delta):
	counter += delta
	if counter > check_time:
		if random.randi_range(1, jump_chance) == 1:
			#jump
			direction = random.randi_range(0, 3)
			if direction == directions.RIGHT:
				sprite.flip_h = true
			elif direction == directions.LEFT:
				sprite.flip_h = false 
			sprite.play("jump")
		counter = 0
	if sprite.animation == "jump":
		if sprite.frame > 7:
			if not landed:
				attack()
			landed = true
			velocity = Vector2.ZERO
		elif sprite.frame > 2:
			landed = false
			velocity = jump_speed * direction_vectors[direction]


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "jump":
		velocity = Vector2.ZERO
		sprite.play("idle")

func _on_HurtBox_area_entered(area):
	if area.is_in_group("hit_box"):
		if area.is_in_group("boomerang"):
			area.get_parent().return_to_player()
		take_damage(area.damage)
		knockback(area.knockback)
		start_invincibility()
