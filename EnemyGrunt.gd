extends KinematicBody2D

var grunt_rot_speed = deg2rad(22.5) # degrees per second
var current_target = null

func _ready():
	var t = get_tree()
	var r = t.get_root()
	var n = r.get_node("Game/MinimapControl")
	n.register_entity(self)
	set_process(true)

func type():
	return "EnemyGrunt"
	
func _process(delta):
	rotate(grunt_rot_speed * delta)
