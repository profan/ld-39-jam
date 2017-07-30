extends KinematicBody2D

var velocity = Vector2(1, 0)
var lifetime = 16 # seconds

onready var sprite = get_node("Sprite")

func _ready():
	set_fixed_process(true)
	
func fire(vel, dir, speed):
	velocity = vel + (dir * speed)
	
func _fixed_process(delta):
	move(velocity * delta)
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
