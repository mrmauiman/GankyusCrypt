extends KinematicBody2D

onready var sprite = get_node("AnimatedSprite")
onready var timer = get_node("Timer")

export(Array, PackedScene) var projectiles
export(Vector2) var projectile_spawn_position
export(float) var down_time = 8
var max_down_damage = 25

onready var player = get_tree().get_root().get_node("TestRoom/Player")
const max_health = 100
var health = max_health

var current_damage_stopper = health - max_down_damage

var boomerang = null

var swipes = ["swipe_right", "swipe_left"]
var rng = RandomNumberGenerator.new()

var shot_timer = 1
var velocity = Vector2.ZERO
var x_goal = 0
var threshold = 2
var speed = 70
var max_dist_speed = 50

var get_up = false
var down = false
var fired = false

func _ready():
	sprite.play("fly")
	rng.randomize()

func _process(delta):
	if sprite.animation == "fly":
		shot_timer -= delta
	
	if sprite.animation in swipes:
		if sprite.frame == 2:
			$HitBox/CollisionShape2D.set_deferred("disabled", false)
			if boomerang != null:
				boomerang.return_to_player()
				boomerang = null
	
	if down:
		if health <= current_damage_stopper:
			start_get_up()
	
	if sprite.animation == "stun":
		if get_up and down:
			sprite.play("get_up")
			down = false
			get_up = false
	
	if shot_timer <= 0:
		shot_timer = 1
		if rng.randi_range(0, 1) == 0:
			shoot_projectile()
	
	if sprite.animation == "blink":
		if sprite.frame == 1 and not fired:
			fired = true
			var projectile = projectiles[rng.randi_range(0, len(projectiles)-1)].instance()
			get_tree().get_root().add_child(projectile)
			projectile.position = to_global(projectile_spawn_position)

func _physics_process(delta):
	if sprite.animation == "fly":
		x_goal = player.global_position.x
		var diff = global_position.x - x_goal
		if abs(diff) > threshold:
			velocity = sign(diff) * Vector2.LEFT * speed * (abs(diff)/max_dist_speed)
			move_and_slide(velocity)

func shoot_projectile():
	sprite.play("blink")

func take_damage(amount):
	health -= amount
	if health < 1:
		down = false
		sprite.set_deferred("animation", "death")
		sprite.set_deferred("frame", 0)
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		$HitBox/CollisionShape2D.set_deferred("disabled", true)
		$AttackBox/CollisionShape2D.set_deferred("disabled", true)
		$StunPoint/CollisionPolygon2D.set_deferred("disabled", true)
		$FallenBody/CollisionShape2D.set_deferred("disabled", true)

func start_get_up():
	get_up = true
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)

func _on_AttackBox_body_entered(body):
	if body.is_in_group("player"):
		sprite.play(swipes[rng.randi_range(0, 1)])
		$StunPoint/CollisionPolygon2D.set_deferred("disabled", true)


func _on_AnimatedSprite_animation_finished():
	sprite.speed_scale = 1
	if sprite.animation in swipes:
		$HitBox/CollisionShape2D.set_deferred("disabled", true)
		$StunPoint/CollisionPolygon2D.set_deferred("disabled", false)
		sprite.play("fly")
	
	if sprite.animation == "stun":
		$HurtBox/CollisionShape2D.set_deferred("disabled", false)
		if not down:
			down = true
			get_up = false
			timer.start(down_time)
			current_damage_stopper = health - max_down_damage
	
	if sprite.animation == "damaged":
		sprite.animation = "stun"
		sprite.frame = 4
	
	if sprite.animation == "get_up":
		$FallenBody/CollisionShape2D.set_deferred("disabled", true)
		$StunPoint/CollisionPolygon2D.set_deferred("disabled", false)
		$AttackBox/CollisionShape2D.set_deferred("disabled", false)
		sprite.play("fly")
	
	if sprite.animation == "blink":
		sprite.play("fly")
		fired = false
	
	if sprite.animation == "death":
		queue_free()


func _on_StunPoint_area_entered(area):
	if area.is_in_group("stunner"):
		sprite.play("stun")
		$FallenBody/CollisionShape2D.set_deferred("disabled", false)
		$StunPoint/CollisionPolygon2D.set_deferred("disabled", true)
		$AttackBox/CollisionShape2D.set_deferred("disabled", true)
		


func _on_HurtBox_area_entered(area):
	if area.is_in_group("hit_box"):
		take_damage(area.damage)
		$HurtBox/CollisionShape2D.set_deferred("disabled", true)
		sprite.play("damaged")


func _on_AttackBox_area_entered(area):
	if area.is_in_group("boomerang"):
		if health <= (max_health * 0.5):
			sprite.play(swipes[rng.randi_range(0, 1)])
			$StunPoint/CollisionPolygon2D.set_deferred("disabled", true)
			sprite.speed_scale = 3
			boomerang = area.get_parent()


func _on_Timer_timeout():
	if down:
		start_get_up()
