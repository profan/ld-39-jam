extends Node

var Asteroid = load("res://Asteroid.tscn")

var total_asteroids = 0
var total_time_passed = 0
var current_threshold = 5

# delay between each spawn of asteroid
var spawn_delay = 1 # seconds

# deps
onready var map = get_parent().get_node("Minimap")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	
	# we gots teh times
	total_time_passed += delta
	spawn_delay -= delta
	
	if total_asteroids < current_threshold and spawn_delay <= 0:
		
		var new_asteroid = Asteroid.instance()
		
		randomize()
		var x = floor(rand_range(1, get_viewport().get_rect().size.x))
		var y = floor(rand_range(1, get_viewport().get_rect().size.y))
		var spawn_pos = Vector2(x, y)
		
		new_asteroid.set_pos(spawn_pos)
		get_parent().add_child(new_asteroid) # add to tree
		map.register_entity(new_asteroid) # register with minimap
		
		total_asteroids += 1
