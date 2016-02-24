
extends RigidBody2D
# mode is character prevents rotating

var speed = 200
var jump_strength = -250
var gravity = 300
var accerleration = 5

var left_current
var left_before

var right_current
var right_before

var jump_current
#var jump_before

var orientation = "right"

var state_player = "no_state"
var state_before = "no_state"

var x_velocity = 0
var target_linear_velocity = 200

func _ready():
	set_applied_force(Vector2(0, gravity))
	get_node("ground_detector").add_exception(self)
	set_fixed_process(true)

func _integrate_forces(state):
	if state_player == "ground":
		state.set_linear_velocity(Vector2(x_velocity, get_linear_velocity().y))


func _fixed_process(delta):
	check_inputs()
	calc_linear_velocity(delta)
	check_orientation()
	check_state()

func check_orientation():
	if left_current == "player_left" and not orientation == "left":
		var node = get_node("orientation")
		node.set_scale(node.get_scale() * Vector2(-1, 1))
		orientation = "left"
	elif right_current == "player_right" and not orientation == "right":
		var node = get_node("orientation")
		node.set_scale(node.get_scale() * Vector2(-1, 1))
		orientation = "right"

func calc_linear_velocity(delta):
	if state_player == "ground":
		if left_current == "player_left":
			x_velocity = lerp(x_velocity, -1 * target_linear_velocity, accerleration * delta)
		if right_current == "player_right":
			x_velocity = lerp(x_velocity, target_linear_velocity, accerleration * delta)
		if left_current == "not_pressed" and not right_current == "player_right":
			x_velocity = lerp(x_velocity, 0, accerleration * delta)
		if right_current == "not_pressed" and not left_current == "player_left":
			x_velocity = lerp(x_velocity, 0, accerleration * delta)
		if jump_current == "player_jump":
			set_axis_velocity(Vector2(0, jump_strength))

func check_state():
	state_before = state_player
	if get_node("ground_detector").is_colliding():
		state_player = "ground"
	else:
		state_player = "air"

func check_inputs():
	var assign
	if Input.is_action_pressed("player_left") and not Input.is_action_pressed("player_right"):
		assign = "player_left"
	else:
		assign = "not_pressed"
	left_before = left_current
	left_current = assign
	
	if Input.is_action_pressed("player_right") and not Input.is_action_pressed("player_left"):
		assign = "player_right"
	else:
		assign = "not_pressed"
	right_before = right_current
	right_current = assign
	
	if Input.is_action_pressed("player_jump"):
		assign = "player_jump"
	else:
		assign = "not_pressed"
	#jump_before = jump_current
	jump_current = assign