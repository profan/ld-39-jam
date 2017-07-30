extends Node2D

export(Array) var thrusters

func set_param(i, v):
	for t in thrusters:
		t.set_param(i, v)

func set_emitting(b):
	for t in thrusters:
		t.set_emitting(b)