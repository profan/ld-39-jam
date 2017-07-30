extends Node2D

var entities
var cam_pos = Vector2(0, 0)

func _ready():
	pass
	
func init(ents):
	entities = ents
	
func it_changed(new_pos):
	cam_pos = get_tree().get_root().get_node("Game/Player").get_pos()
	update()

func _draw():
	var vp_rect = get_viewport().get_rect()
	# draw player in center
	var p_mw = (vp_rect.size.x / 2) - 1
	var p_mh = (vp_rect.size.y / 2) - 1
	draw_rect(Rect2(p_mw, p_mh, 2, 2), Color(0, 1, 0))
	for e in entities:
		var ent = e.get_ref()
		var ent_pos = ent.get_global_pos()
		var s_mw = vp_rect.size.x / 2
		var s_mh = vp_rect.size.y / 2
		var s_x = s_mw + (ent_pos.x / vp_rect.size.x) - (cam_pos.x / vp_rect.size.x)
		var s_y = s_mh + (ent_pos.y / vp_rect.size.y) - (cam_pos.y / vp_rect.size.y)
		draw_rect(Rect2(s_x, s_y, 2, 2), Color(1, 1, 1))