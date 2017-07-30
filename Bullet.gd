extends KinematicBody2D

var velocity = Vector2(1, 0)
var lifetime = 16 # seconds

onready var sprite = get_node("Sprite")

func _ready():
	set_fixed_process(true)
	
func fire(delta, vel, dir, speed):
	velocity = (vel.length() * dir + (dir * speed * delta))
	sprite.rotate(dir.angle())

func _fixed_process(delta):
	move(velocity)
	lifetime -= delta
	if lifetime <= 0:
		queue_free()