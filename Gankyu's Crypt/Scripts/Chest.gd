extends Sprite

export(NodePath) var player_path
var player

enum Items {KEY, BOSS_KEY_1, BOSS_KEY_2, BOSS_KEY, POTION, BOOMERANG}
export(Items) var contents

var opened = false

func _ready():
	player = get_node(player_path)

func open():
	if (not opened):
		opened = true
		$Item.frame = contents
		$AnimationPlayer.play("ItemRise")

func give_player_item():
	player.recieve(contents)


func _on_OpenCollision_body_entered(body):
	if(body.is_in_group("player")):
		body.chest = self


func _on_OpenCollision_body_exited(body):
	if(body.is_in_group("player")):
		body.chest = null
