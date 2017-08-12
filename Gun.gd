extends Node2D

var Bullet = load("res://Bullet.tscn")

var gun_cooldown = 0
var gun_delay = 0.1125
var gun_spread_max = deg2rad(4) # degrees max
var gun_bullet_speed = 384

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	gun_cooldown = clamp(gun_cooldown - delta, 0, 1)

func fire(delta, vel, dir):
	if gun_cooldown <= 0:
		var new_bullet = Bullet.instance()
		var gun_pos = get_global_pos()
		new_bullet.set_pos(gun_pos + vel)
		get_tree().get_root().add_child(new_bullet)
		var rot = rand_range(-gun_spread_max, gun_spread_max)
		new_bullet.fire(delta, vel, dir.rotated(rot), gun_bullet_speed)
		gun_cooldown += gun_delay
