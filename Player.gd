extends KinematicBody2D

onready var sprite = get_node("Sprite")
onready var camera = get_node("Camera2D")

var mov_speed = 64 # pixels per second
var ship_vel = Vector2(0, 0)
var ship_max_vel = 100 # pixels per second
var ship_accel = 25 # pixels per second.. per second?
var ship_turn_speed = deg2rad(360) # degrees per second.. i guess?
var ship_mass = 61

var ship_dir = Vector2(1, 0)

func _ready():
	set_fixed_process(true)
	
func turn_towards(delta, pos):
	
	var target_dir = (pos - get_global_pos()).normalized()
	var cpd = target_dir.dot(ship_dir.rotated(deg2rad(90)))

	var as = asin(cpd)
	var ca = clamp(as, (-ship_turn_speed) * delta, (ship_turn_speed) * delta)

	ship_dir = ship_dir.rotated(-ca)
	
func _fixed_process(delta):
	
	var mov_delta = Vector2(0, 0)
	turn_towards(delta, get_global_mouse_pos())

	if Input.is_action_pressed("player_move_forwards"):
		mov_delta += -ship_dir
	elif Input.is_action_pressed("player_move_backwards"):
		mov_delta += ship_dir

	sprite.set_rot(ship_dir.angle())

	var new_vel = (ship_vel + (mov_delta * (delta * ship_accel))).clamped(ship_max_vel)
	var diff = new_vel - ship_vel
	ship_vel += diff
	
	self.move(ship_vel)
	ship_vel = ship_vel / (delta * ship_mass)
