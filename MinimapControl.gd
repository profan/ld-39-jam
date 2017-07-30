extends CanvasLayer

onready var map = get_node("Minimap")

var n_frames = 5
var frames_passed = 0

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	frames_passed += 1
	if frames_passed >= n_frames:
		frames_passed = 0
		map.update()

func register_entity(e):
	map.register_entity(e)