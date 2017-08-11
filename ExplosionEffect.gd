extends Sprite

var current_time = 0
var frames_per_second = 0.05

func _ready():
	set_process(true)

func _process(delta):
	
	if int(current_time / frames_per_second) >= get_hframes() - 1:
		queue_free()
	
	set_frame(int(current_time / frames_per_second))
	current_time += delta