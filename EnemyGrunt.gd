extends KinematicBody2D

const km = preload("Kinematic.gd")

var grunt_max_speed = 256 # pixels per second
var grunt_arrive_radius = 64
var grunt_arrive_speed = 1
var grunt_rot_speed = deg2rad(22.5) # degrees per second

var cur_kinematic
var steering
var s_seek
var s_arrive

func _ready():
	var t = get_tree().get_root().get_node("Game/MinimapControl").register_entity(self)
	set_fixed_process(true)
	set_process(true)
	
	cur_kinematic = km.Kinematic.new(self, grunt_max_speed)
	steering = km.Steering.new()
	
	s_seek = km.Seek.new(self)
	s_arrive = km.Arrive.new(self, grunt_arrive_radius, grunt_arrive_speed)
	
	var player = get_tree().get_root().get_node("Game/Player")
	s_seek.set_target(player)
	s_arrive.set_target(player)

func type():
	return "EnemyGrunt"
	
func _fixed_process(delta):
	s_seek.get_steering(steering)
	s_arrive.get_steering(steering)
	cur_kinematic.update(steering, delta)
	
func _process(delta):
	pass
	# rotate(grunt_rot_speed * delta)
