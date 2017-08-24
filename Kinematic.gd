extends Script

class Kinematic:
	
	var owner
	var velocity = Vector2(0, 0) # velocity to apply to position
	var orientation = Vector2(0, 0) # current orientation
	var rotation = 0.0 # radians to rotate
	
	# per instance custom
	var max_speed
	
	func _init(o, m):
		owner = o
		max_speed = m
	
	func get_position():
		return owner.get_kinematic_position()
	
	func get_orientation():
		return velocity.normalized()
	
	func update(steering, delta):
		
		owner.move(velocity * delta)
		# owner.set_pos(owner.get_pos() + velocity * delta)
		if velocity.length() > 0:
			owner.set_rot(velocity.normalized().angle())
		
		velocity += steering.velocity * delta
		rotation += steering.rotation * delta
		
		# clip at max speed
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed

class Steering:
	var velocity = Vector2(0, 0)
	var rotation = 0

class Seek:
	
	var owner
	var target
	var max_rot_speed = deg2rad(64) # degrees per second
	
	func _init(o):
		owner = o
	
	func get_steering(s):
		if target == null: return
		var tr = target.get_ref()
		if tr:
			# update velocity
			s.velocity = tr.get_kinematic_position() - owner.get_global_pos()
			# update orientation
			# if velocity.length() > 0:
			#	rotation = clamp(velocity.normalized().angle(), -max_rot_speed, max_rot_speed)
		else:
			target = null
	
	func set_target(t):
		if t != null:
			target = weakref(t)
		else:
			target = null
		
class Arrive:
	
	var owner
	var target
	
	# custom
	var radius = 0
	var time_to_target = 0
	
	func _init(o, r, a):
		owner = o
		radius = r
		time_to_target = a
	
	func get_steering(s):
		if target == null: return
		var tr = target.get_ref()
		if tr:
			if s.velocity.length() < radius:
				s.velocity.x = 0
				s.velocity.y = 0
			s.velocity /= time_to_target
		else:
			target = null
	
	func set_target(t):
		target = weakref(t)

class AvoidTarget:
	
	var position
	
	func _init(p):
		position = p
	
	func get_kinematic_position():
		return position

class Avoid extends Seek:
	
	var avoid_target = AvoidTarget.new(Vector2(0, 0))
	var avoid_distance = 128
	
	func _init(o, a).(o):
		a.connect("body_enter_shape", self, "on_body_enter_feeler")
		a.connect("body_exit_shape", self, "on_body_exit_feeler")
	
	func set_turn_direction(body, id):
		var cp = body.get_collision_pos()
		var cn = body.get_collision_normal()
		avoid_target.position = cp + cn * avoid_distance
	
	func on_body_enter_feeler(body_id, body, body_shape, area_shape):
		set_turn_direction(body, area_shape)
		.set_target(avoid_target)
		print("Y", area_shape)
	
	func on_body_exit_feeler(body_id, body, body_shape, area_shape):
		.set_target(null)
		print("N", area_shape)
		
	func get_steering(s):
		if target == null: return
		return .get_steering(s)

class Flee:
	func init():
		pass
		
	func get_steering():
		pass

func _ready():
	pass
