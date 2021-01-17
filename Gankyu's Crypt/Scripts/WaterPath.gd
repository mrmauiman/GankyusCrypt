extends Sprite

var filled = false
var touching = null
var source_is_touching = false

func remove_water():
	source_is_touching = false
	$AnimatedSprite.animation = "drain"
	filled = false
	get_node("../../..").drain()
	$DropOff.display(false)

func add_water(is_source):
	source_is_touching = is_source
	$AnimatedSprite.animation = "fill"
	filled = true
	get_node("../../..").fill()

func _process(delta):
	if (GlobalVariables.DEBUG_MODE):
		if (source_is_touching):
			$Line2D.points = [to_local(global_position), to_local(touching.global_position)]
		else:
			var offset = Vector2(0, -48)
			$Line2D.points = [to_local(global_position), to_local(global_position) + offset]

func _physics_process(delta):
	if (touching and not filled):
		if (touching.is_in_group("watersource")):
			add_water(true)
		else:
			if (touching.get_parent().filled):
				add_water(true)
	elif (not touching and filled):
		if (source_is_touching):
			remove_water()

func _on_Area2D_area_entered(area):
	if area.is_in_group("watersource") or area.is_in_group("water_path"):
		touching = area


func _on_Area2D_area_exited(area):
	if area.is_in_group("watersource") or area.is_in_group("water_path"):
		touching = null


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "fill":
		$AnimatedSprite.animation = "idle"
		if (touching == null):
			$DropOff.display(true)
