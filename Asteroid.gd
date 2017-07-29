extends KinematicBody2D

var rect = Rect2(0, 0, 0, 0)
var velocity = Vector2(0, 0)
var rot_vel = 0

var max_vel = 6 # pixels per second?
var max_rot_vel = 2.5 # degrees per second 

func _ready():
	randomize()
	velocity.x = floor(rand_range(-max_vel, max_vel))
	velocity.y = floor(rand_range(-max_vel, max_vel))
	rect.size.x = floor(rand_range(32, 64))
	rect.size.y = floor(rand_range(32, 64))
	rot_vel = deg2rad(floor(rand_range(1, max_rot_vel)))
	set_fixed_process(true)
	
func wrap(v, v_min, v_max):
	if v < v_min:
		return v_max - 1
	elif v > v_max:
		return v_min - 1
	else:
		return v

func _fixed_process(delta):
	
	var cur_pos = get_pos()
	cur_pos.x = wrap(cur_pos.x, 1, get_viewport().get_rect().size.x)
	cur_pos.y = wrap(cur_pos.y, 1, get_viewport().get_rect().size.y)
	set_pos(cur_pos)
	
	self.move(velocity)
	self.rotate(rot_vel)

func _draw():
	draw_rect(rect, Color(0x42, 0x8b, 0xca))