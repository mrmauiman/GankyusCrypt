extends Area2D

var enemies = []
var enemy_transforms = []
var blocks = []
var block_transforms = []
var chests = []
var chest_transforms = []

var done = false
var spawned = false
var block_index = 0

func _ready():
	for node in get_children():
		if node.is_in_group("enemy"):
			enemies.append(node)
			enemy_transforms.append(node.transform)
			remove_child(node)
		if node.is_in_group("block"):
			blocks.append(node)
			block_transforms.append(node.transform)
			remove_child(node)
		if node.is_in_group("chest"):
			chests.append(node)
			chest_transforms.append(node.transform)
			remove_child(node)

func _process(delta):
	if spawned and not done:
		var counter = 0
		for enemy in enemies:
			if enemy == null:
				counter += 1
		if counter == len(enemies):
			open_blocks()
			reveal_chests()

func reveal_chests():
	for i in range(len(chests)):
		add_child(chests[i])
		chests[i].transform = chest_transforms[i]
		chests[i].player = get_node("../../Player")

func open_block():
	if block_index < len(blocks):
		blocks[block_index].open()
		block_index += 1
		if block_index < len(blocks):
			$Timer.start(0.6)

func open_blocks():
	block_index = 0
	open_block()
	done = true

func spawn():
	for i in range(len(enemies)):
		add_child(enemies[i])
		enemies[i].transform = enemy_transforms[i]
	
	for i in range(len(blocks)):
		add_child(blocks[i])
		blocks[i].transform = block_transforms[i]
	
	get_node("CollisionShape2D").set_deferred("disabled", true)
	spawned = true


func _on_RoomSpawner_body_entered(body):
	if body.is_in_group("player"):
			spawn()


func _on_Timer_timeout():
	open_block()
