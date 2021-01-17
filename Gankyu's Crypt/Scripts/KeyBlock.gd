extends Sprite

enum types {KEY, BOSSKEY}
export(types) var type = types.KEY

func _ready():
	match(type):
		types.KEY:
			frame = 0
		types.BOSSKEY:
			frame = 3

func _on_Area2D_body_entered(body):
	if (body.is_in_group("player")):
		match(type):
			types.KEY:
				if (body.keys > 0):
					body.keys -= 1
					queue_free()
			types.BOSSKEY:
				if (body.boss_key_1 && body.boss_key_2):
					queue_free()
