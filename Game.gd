extends Node

var cursor_texture = load("res://img/crosshair.tex")

func _ready():
	Input.set_custom_mouse_cursor(cursor_texture)
