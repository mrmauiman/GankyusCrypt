extends Camera2D

var goal_constraints = null
export(float) var smooth_speed = 1.5
const scale_threshold = 40
const pos_threshold = 40
const side_map = {
	"left": MARGIN_LEFT,
	"right": MARGIN_RIGHT,
	"top": MARGIN_TOP,
	"bottom": MARGIN_BOTTOM
}
const extra = 3


func set_limits(constraints):
	for margin in constraints:
		set_limit(side_map[margin], constraints[margin])

func margins_to_rect(margins):
	var rect = Rect2()
	rect.position = Vector2(margins["left"], margins["top"])
	rect.end = Vector2(margins["right"], margins["bottom"])
	return rect

func rect_to_margins(rect):
	return {
		"left": rect.position.x,
		"right": rect.end.x,
		"top": rect.position.y,
		"bottom": rect.end.y
	}

func camera_in_constraints(constraints):
	var viewport = get_viewport_rect()
	viewport.position = get_camera_screen_center() - (viewport.size/2.0)
	var constraints_rect = margins_to_rect(constraints)
	if viewport.position.x < (constraints_rect.position.x - extra):
		return false
	if viewport.position.y < (constraints_rect.position.y - extra):
		return false
	if viewport.end.x > (constraints_rect.end.x + extra):
		return false
	if viewport.end.y > (constraints_rect.end.y + extra):
		return false
	return true

func include(constraints):
	var limits = {
		"left": limit_left,
		"right": limit_right,
		"top": limit_top,
		"bottom": limit_bottom
	}
	var limits_rect = margins_to_rect(limits)
	var constraints_rect = margins_to_rect(constraints)
	var combined = constraints_rect.merge(limits_rect)
	set_limits(rect_to_margins(combined))

func set_constraints(constraints, smooth):
	goal_constraints = constraints
	if not smooth or camera_in_constraints(constraints):
		set_limits(constraints)
		goal_constraints = null
	else:
		include(constraints)
		goal_constraints = constraints

func get_closest_in_constraints(pos):
	var rect = get_viewport_rect()
	rect.position = pos - (rect.size/2.0)
	var new_offset = Vector2.ZERO
	if rect.position.x < goal_constraints["left"]:
		new_offset.x = (goal_constraints["left"] - rect.position.x)
	elif rect.end.x > goal_constraints["right"]:
		new_offset.x = (goal_constraints["right"] - rect.end.x)
	
	if rect.position.y < goal_constraints["top"]:
		new_offset.y = (goal_constraints["top"] - rect.position.y)
	elif rect.end.y > goal_constraints["bottom"]:
		new_offset.y = (goal_constraints["bottom"] - rect.end.y)
	
	return new_offset

func move_towards_goal():
	if goal_constraints != null:
		if camera_in_constraints(goal_constraints):
			set_limits(goal_constraints)
			goal_constraints = null
		else:
			var player_pos = get_parent().global_position
			var goal = get_closest_in_constraints(player_pos)
			set_offset(goal, true)

func set_offset(value, relative = false):
	if not relative:
		value = to_local(value)
	position = value

func zoomout():
	zoom = Vector2(1.5, 1.5)

func zoomin():
	zoom = Vector2(1, 1)

func _physics_process(delta):
	move_towards_goal()
