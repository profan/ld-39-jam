extends KinematicBody2D

var ExplosionEffect = load("res://ExplosionEffect.tscn")

onready var sprite = get_node("Sprite")
onready var camera = get_node("Camera2D")
onready var left_particles = get_node("Sprite/LeftThruster")
onready var right_particles = get_node("Sprite/RightThruster")
onready var engine_particles = get_node("Sprite/Engine")
onready var left_gun = get_node("Sprite/LeftGun")
onready var right_gun = get_node("Sprite/RightGun")
onready var audio = get_node("SamplePlayer")

var mov_speed = 64 # pixels per second
var ship_vel = Vector2(0, 0)
var ship_max_vel = 100 # pixels per second
var ship_accel = 25 # pixels per second.. per second?
var ship_turn_speed = deg2rad(180) # degrees per second.. i guess?
var ship_dir = Vector2(1, 0)
var ship_mass = 61

var ship_health = 100
var player_is_dead = false

var is_moving = false
var missiles_locked_on = 0
var is_engine_playing = false
var enemy_missiles = Array()

var bleep_timer = 0
var bleep_delay = 0.5

func _ready():
	set_fixed_process(true)
	left_particles.set_emitting(false)
	right_particles.set_emitting(false)
	
func type():
	return "Player"
	
func do_damage(v):
	ship_health -= v
	
func get_kinematic_position():
	return get_global_pos() + ship_vel

func on_enemy_missile_lock(m):
	enemy_missiles.append(m)
	missiles_locked_on += 1
	
func on_enemy_missile_lock_lost(m):
	enemy_missiles.erase(m)
	missiles_locked_on -= 1
	if missiles_locked_on <= 0:
		pass

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
	
func get_closest_missile_distance():
	var min_dist = 1000
	for m in enemy_missiles:
		var mis_dist = get_global_pos().distance_to(m.get_global_pos())
		if mis_dist < min_dist:
			min_dist = mis_dist
	return min_dist
	
func player_explode():
	# create explosion effect
	var new_ee = ExplosionEffect.instance()
	get_tree().get_root().add_child(new_ee)
	new_ee.set_global_pos(get_global_pos())
	player_is_dead = true

func _fixed_process(delta):
	
	if ship_health <= 0 and not player_is_dead:
		player_explode()
	
	if player_is_dead:
		return
	
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
		
	# get closest enemy missile, calc distance
	var closest_missile_dist = get_closest_missile_distance()
	
	if closest_missile_dist == 1000:
		bleep_delay = 0.5
	else:
		bleep_delay = closest_missile_dist / 1000
	
	bleep_timer += delta
	if missiles_locked_on > 0 and bleep_timer > bleep_delay:
		if closest_missile_dist > 10:
			audio.play("friendly_blip")
			bleep_timer = 0
		
	if is_moving and not is_engine_playing:
		is_engine_playing = true
		# audio.play("engine")
	elif not is_moving:
		is_engine_playing = false
		# audio.stop(0)

	set_rot(ship_dir.angle())

	var new_vel = (ship_vel + (mov_delta * (delta * ship_accel))).clamped(ship_max_vel)
	var diff = new_vel - ship_vel
	ship_vel += diff
	
	self.move(ship_vel)
	ship_vel = ship_vel / (delta * ship_mass)
	
	engine_particles.set_emitting(is_moving)
