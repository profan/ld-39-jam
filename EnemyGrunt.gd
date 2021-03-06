extends KinematicBody2D

onready var gun = get_node("Ship/Gun")
onready var launcher = get_node("Ship/MissileLauncher")
onready var firing_area = get_node("FiringCone")
onready var avoid_area = get_node("AvoidCone")

var ExplosionEffect = load("res://ExplosionEffect.tscn")

const km = preload("Kinematic.gd")

var grunt_max_speed = 256 # pixels per second
var grunt_arrive_radius = 64
var grunt_arrive_speed = 1
var grunt_rot_speed = deg2rad(22.5) # degrees per second

var health = 100

var cur_kinematic
var steering
var s_seek
var s_arrive
var s_avoid

var player_in_cone = false

func _ready():
	var t = get_tree().get_root().get_node("Game/MinimapControl").register_entity(self)
	set_fixed_process(true)
	
	gun.set_owner(type())
	
	cur_kinematic = km.Kinematic.new(self, grunt_max_speed)
	steering = km.Steering.new()
	
	s_seek = km.Seek.new(self)
	s_arrive = km.Arrive.new(self, grunt_arrive_radius, grunt_arrive_speed)
	s_avoid = km.Avoid.new(self, avoid_area)
	
	var player = get_tree().get_root().get_node("Game/Player")
	s_seek.set_target(player)
	s_arrive.set_target(player)
	
	# firing cone!
	firing_area.connect("body_enter", self, "on_body_enter_firing_cone")
	firing_area.connect("body_exit", self, "on_body_exit_firing_cone")
	
func on_body_enter_firing_cone(b):
	if b.type() == "Player":
		player_in_cone = true

func on_body_exit_firing_cone(b):
	if b.type() == "Player":
		player_in_cone = false
	
func on_explode():
	# create explosion effect
	var new_ee = ExplosionEffect.instance()
	get_tree().get_root().add_child(new_ee)
	new_ee.set_global_pos(get_global_pos())
	queue_free()
	
func do_damage(v):
	health -= v

func type():
	return "Enemy"
	
func get_kinematic_position():
	return get_global_pos() + cur_kinematic.velocity
	
func _fixed_process(delta):
	
	s_seek.get_steering(steering)
	s_arrive.get_steering(steering)
	s_avoid.get_steering(steering)
	cur_kinematic.update(steering, delta)
	
	# pass on velocity
	launcher.set_velocity(cur_kinematic.velocity)
	
	if player_in_cone:
		gun.fire(delta, cur_kinematic.velocity * delta, cur_kinematic.get_orientation())
	
	if health <= 0:
		on_explode()

func _process(delta):
	pass
