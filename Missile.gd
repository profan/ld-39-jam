extends KinematicBody2D

const km = preload("Kinematic.gd")
var MissileImpact = load("res://MissileImpact.tscn")

onready var sprite = get_node("Sprite")
onready var ps = get_node("Particles2D")
onready var cs = get_node("CollisionShape2D")
onready var avoid_area = get_node("AvoidCone")

var missile_max_speed = 384 # pixels per second
var missile_arrive_radius = 64
var missile_arrive_speed = 1
var missile_rot_speed = deg2rad(22.5) # degrees per second
var missile_dmg = 100

var cur_kinematic
var steering
var s_seek
var s_arrive

# is dead?
var is_dead = false

# time to die
var death_time = 1

# current timer
var death_timer = 0

func _ready():
	set_fixed_process(true)
	
	cur_kinematic = km.Kinematic.new(self, missile_max_speed)
	steering = km.Steering.new()
	
	s_seek = km.Seek.new(self)
	s_arrive = km.Arrive.new(self, missile_arrive_radius, missile_arrive_speed)
	
	var player = get_tree().get_root().get_node("Game/Player")
	s_seek.set_target(player)
	s_arrive.set_target(player)
	
	player.on_enemy_missile_lock(self)
	
	# base death timer on lifetime
	death_time = ps.get_lifetime()
	
func set_velocity(vel):
	cur_kinematic.velocity = vel

func on_impact(e, is_bullet):
	
	# create bullet impact
	var new_mi = MissileImpact.instance()
	# e.add_child(new_mi)
	get_tree().get_root().add_child(new_mi)
	#new_bi.set_global_pos(get_collision_pos() + velocity/2)
	new_mi.set_scale(Vector2(1.5, 1.5)) # when missile, larger effect
	new_mi.set_global_pos(get_collision_pos())
	
	if not is_bullet:
		# align along "hit normal, the lazy way"
		new_mi.set_global_rot((-get_collision_normal()).angle())
	else:
		new_mi.set_global_rot(get_global_rot())
		new_mi.rotate(deg2rad(180))
	
	# damage and free
	e.do_damage(missile_dmg)
	
	# hide missile, keep particles until dedness
	queue_death()

func queue_death():
	sprite.hide()
	ps.set_emitting(false)
	cs.queue_free() # kill it
	get_tree().get_root().get_node("Game/Player").on_enemy_missile_lock_lost(self)
	is_dead = true
	
func _fixed_process(delta):
	
	if is_dead:
		death_timer += delta
		if death_timer >= death_time:
			queue_free()
		return
	
	s_seek.get_steering(steering)
	s_arrive.get_steering(steering)
	cur_kinematic.update(steering, delta)
	
	if is_colliding():
		var e = get_collider()
		var e_t = e.type()
		if e_t == "Bullet":
			on_impact(e, true)
		elif e_t != "Missile":
			on_impact(e, false)
	
func type():
	return "Missile"
