extends Node2D

var Missile = load("res://Missile.tscn")

var launch_timer = 0
var launch_delay = 5 # 5 seconds
var velocity = Vector2(0, 0)

onready var map = get_tree().get_root().get_node("Game/MinimapControl")

func _ready():
	set_process(true)
	
func set_velocity(vel):
	velocity = vel
	
func launch_missile():
	
	# create
	var new_missile = Missile.instance()
	var missile_pos = get_global_pos()
	new_missile.set_global_pos(missile_pos)
	get_tree().get_root().add_child(new_missile)
	new_missile.set_velocity(velocity)
	
	# register with minimap
	map.register_entity(new_missile)

func _process(delta):
	launch_timer += delta
	if launch_timer >= launch_delay:
		launch_missile()
		launch_timer = 0