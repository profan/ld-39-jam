extends KinematicBody2D

func _ready():
	var t = get_tree()
	var r = t.get_root()
	var n = r.get_node("Game/MinimapControl")
	n.register_entity(self)
	
func type():
	return "EnemyGrunt"
