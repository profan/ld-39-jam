extends Control

var offset_pos = Vector2(32, 32)

onready var render_target = get_node("Viewport")
onready var tex_frame = get_node("TextureFrame")

var entities = Array()

func _ready():
	set_fixed_process(true)
	tex_frame.set_texture(render_target.get_render_target_texture())
	render_target.init(entities)
	set_pos(Vector2(32, 32))

func register_entity(e):
	entities.append(weakref(e))
	render_target.init(entities)

func collect_entities():
	var to_remove
	for i in range(0, entities.size()):
		if not entities[i].get_ref():
			if to_remove == null:
				print ("create")
				to_remove = Array()
			to_remove.push_back(entities[i])
	# pass down updated
	if to_remove != null:
		for e in to_remove:
			entities.erase(e)
		render_target.init(entities)

func _fixed_process(delta):
	collect_entities()

func _draw():
	if entities.size() > 0:
		render_target.render_target_clear()
		render_target.it_changed()
		# gc the shit out of em
		collect_entities()