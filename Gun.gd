extends Sprite

var Bullet = load("res://Bullet.tscn")

var gun_cooldown = 0
var gun_delay = 0.1125

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
		new_bullet.fire(delta, vel, dir, 512)
		gun_cooldown += gun_delay
