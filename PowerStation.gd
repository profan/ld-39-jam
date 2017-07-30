extends KinematicBody2D

var rotation_speed = deg2rad(11.25) # degrees per second

func _ready():
	var t = get_tree()
	var r = t.get_root()
	var n = r.get_node("Game/MinimapControl")
	n.register_entity(self)
	set_process(true)

func type():
	return "PowerStation"
	
func _process(delta):
	self.rotate(rotation_speed * delta)