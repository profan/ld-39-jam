extends KinematicBody2D

var BulletImpact = load("res://BulletImpact.tscn")

var velocity = Vector2(1, 0)
var lifetime = 16 # seconds

var bullet_dmg = 25

onready var sprite = get_node("Sprite")

func _ready():
	set_fixed_process(true)

func fire(delta, vel, dir, speed):
	velocity = (vel.length() * dir + (dir * speed * delta))
	sprite.set_rot(dir.angle())

func type():
	return "Bullet"
	
func do_damage(v):
	lifetime = 0
	
func on_impact(e):
	
	# create bullet impact
	var new_bi = BulletImpact.instance()
	e.add_child(new_bi)
	# get_tree().get_root().add_child(new_bi)
	#new_bi.set_global_pos(get_collision_pos() + velocity/2)
	new_bi.set_global_pos(get_collision_pos())
	
	# align along "hit normal, the lazy way"
	new_bi.set_global_rot((-get_collision_normal()).angle())
	
	# new_bi.rotate(deg2rad(180))
	
	# damage and free
	e.do_damage(bullet_dmg)
	queue_free()

func _fixed_process(delta):
	
	move(velocity)
	lifetime -= delta
	
	if is_colliding():
		var e = get_collider()
		var e_t = e.type()
		if e_t == "Asteroid" or e_t == "Enemy" or e_t == "PowerStation":
			on_impact(e)
	
	if lifetime <= 0:
		queue_free()