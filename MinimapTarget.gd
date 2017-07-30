extends Viewport

onready var child = get_node("Drawer")

func _ready():
	pass

func init(ents):
	child.init(ents)
	
func it_changed(new_pos):
	child.it_changed(new_pos)