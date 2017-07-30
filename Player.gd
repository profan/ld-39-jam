extends KinematicBody2D

onready var sprite = get_node("Sprite")
onready var camera = get_node("Camera2D")
onready var left_particles = get_node("Sprite/LeftThruster")
onready var right_particles = get_node("Sprite/RightThruster")
onready var engine_particles = get_node("Sprite/Engine")
onready var left_gun = get_node("Sprite/LeftGun")
onready var right_gun = get_node("Sprite/RightGun")

var mov_speed = 64 # pixels per second
var ship_vel = Vector2(0, 0)
var ship_max_vel = 100 # pixels per second
var ship_accel = 25 # pixels per second.. per second?
var ship_turn_speed = deg2rad(180) # degrees per second.. i guess?
var ship_dir = Vector2(1, 0)
var ship_mass = 61

var is_moving = false

func _ready():
	set_fixed_process(true)
	left_particles.set_emitting(false)
	right_particles.set_emitting(false)
	
func turn_towards(delta, pos):
	
	var target_dir = (pos - get_global_pos()).normalized()
	var cpd = target_dir.dot(ship_dir.rotated(deg2rad(90)))

	var as = asin(cpd)
	var ca = clamp(as, (-ship_turn_speed) * delta, (ship_turn_speed) * delta)
	
	left_particles.set_param(Particles2D.PARAM_LINEAR_VELOCITY, 400 * abs(ca))
	right_particles.set_param(Particles2D.PARAM_LINEAR_VELOCITY, 400 * abs(ca))
	
	if ca < -0.01:
		left_particles.set_emitting(false)
		right_particles.set_emitting(true)
	elif ca > 0.01:
		left_particles.set_emitting(true)
		right_particles.set_emitting(false)
	else:
		left_particles.set_emitting(false)
		right_particles.set_emitting(false)

	ship_dir = ship_dir.rotated(-ca)
	
func _fixed_process(delta):
	
	var mov_delta = Vector2(0, 0)
	turn_towards(delta, get_global_mouse_pos())

	if Input.is_action_pressed("player_move_forwards"):
		is_moving = true
		mov_delta += -ship_dir
	elif Input.is_action_pressed("player_move_backwards"):
		mov_delta += ship_dir
	else:
		is_moving = false
		
	if Input.is_action_pressed("player_attack_primary"):
		left_gun.fire(delta, ship_vel, -ship_dir)
		right_gun.fire(delta, ship_vel, -ship_dir)
	elif Input.is_action_pressed("player_attack_secondary"):
		pass

	if Input.is_action_pressed("player_switch_up"):
		pass
	elif Input.is_action_pressed("player_switch_down"):
		pass

	sprite.set_rot(ship_dir.angle())

	var new_vel = (ship_vel + (mov_delta * (delta * ship_accel))).clamped(ship_max_vel)
	var diff = new_vel - ship_vel
	ship_vel += diff
	
	self.move(ship_vel)
	ship_vel = ship_vel / (delta * ship_mass)
	
	engine_particles.set_emitting(is_moving)
