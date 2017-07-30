extends Viewport

onready var child = get_node("Drawer")

func _ready():
	pass

func init(ents):
	child.init(ents)
	
func it_changed():
	child.it_changed()