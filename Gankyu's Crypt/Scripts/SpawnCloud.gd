extends AnimatedSprite

export(PackedScene) var enemy

var roam = null

func _ready():
	frame = 0
	playing = true

func _on_SpawnCloud_animation_finished():
	get_parent().set_state(roam)
	queue_free()
