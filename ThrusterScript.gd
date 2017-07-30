extends Node2D

onready var t_one = get_node("thruster_one")
onready var t_two = get_node("thruster_two")

func _ready():
	pass

func set_param(p, v):
	t_one.set_param(p, v)
	t_two.set_param(p, v)
	
func set_emitting(b):
	t_one.set_emitting(b)
	t_two.set_emitting(b)