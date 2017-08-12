extends Node2D

onready var sprite = get_node("Sprite")
onready var ps = get_node("Particles2D")

var current_time = 0
var frames_per_second = 0.05
var total_time = 0
var done = false

func _ready():
	set_process(true)
	total_time = sprite.get_hframes() * frames_per_second + 0.75 # 4 extra seconds for particle blast
	ps.set_process(false)

func _process(delta):
	
	ps.set_process(true)
	
	if not int(current_time / frames_per_second) >= sprite.get_hframes() - 1:
		sprite.set_frame(int(current_time / frames_per_second))
	elif not done:
		sprite.hide()
		done = true
	
	current_time += delta
	
	if current_time >= total_time:
		queue_free()