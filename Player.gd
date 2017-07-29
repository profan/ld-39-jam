extends Node2D

var mov_direction = Vector2(1, 0)
var mov_speed = 128 # pixels per second

var cur_frame = 0
var cur_time_per_frame = 0.1
var cur_time = 0
var cur_moving = true

onready var sprite = get_node("Sprite")

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):

	var mov_delta = Vector2(0, 0)
	var mov_direction = Vector2(1, 0)
	
	# move towards mouse
	mov_direction = (get_viewport().get_mouse_pos() - get_global_pos()).normalized()
	
	if Input.is_action_pressed("player_move_forwards") or Input.is_action_pressed("player_move_backwards") or Input.is_action_pressed("player_move_left") or Input.is_action_pressed("player_move_right"):
		if Input.is_action_pressed("player_move_forwards"):
			mov_delta.y -= 1 * (mov_speed * delta)
			# mov_delta = mov_direction * (mov_speed * delta)
			cur_moving = true
		elif Input.is_action_pressed("player_move_backwards"):
			# mov_delta = (-mov_direction) * (mov_speed * delta)
			mov_delta.y += 1 * (mov_speed * delta)
			cur_moving = true
		if Input.is_action_pressed("player_move_left"):
			mov_delta.x -= 1 * (mov_speed * delta)
			cur_moving = true
		elif Input.is_action_pressed("player_move_right"):
			mov_delta.x += 1 * (mov_speed * delta)
			cur_moving = true
	else:
		cur_moving = false
	

	if Input.is_action_pressed("player_attack"):
		pass

	cur_time = cur_time + delta

	if cur_moving and cur_frame != 6:
		if cur_time > cur_time_per_frame:
			cur_frame += 1
			cur_time = 0
	else:
		if cur_moving:
			cur_frame = 1
		else:
			cur_frame = 0

	# set frame shit
	sprite.set_frame(cur_frame)
	sprite.set_rot(sprite.get_global_pos().angle_to_point(get_viewport().get_mouse_pos()))

	# do teh moves
	move_local_x(mov_delta.x)
	move_local_y(mov_delta.y)
	
func _process(delta):
	pass
