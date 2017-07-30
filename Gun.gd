extends Sprite

var Bullet = load("res://Bullet.tscn")

var gun_cooldown = 0
var gun_delay = 0.25

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	gun_cooldown = gun_cooldown - delta
	
func fire(vel, dir):
	if gun_cooldown <= 0:
		var new_bullet = Bullet.instance()
		var gun_pos = get_global_pos()
		new_bullet.set_pos(gun_pos)
		get_tree().get_root().add_child(new_bullet)
		new_bullet.fire(vel, dir, 256)	
		gun_cooldown += gun_delay
