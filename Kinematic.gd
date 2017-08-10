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
		return owner.get_global_pos()
	
	func get_orientation():
		return velocity.normalized()
	
	func update(steering, delta):
		
		owner.move(velocity * delta)
		owner.set_rot(velocity.normalized().angle())
		# owner.rotate(rotation * delta)
		velocity += steering.velocity * delta
		rotation += steering.rotation * delta
		
		# clip at kinematic
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed

class Seek:
	
	var owner
	var target
	var max_rot_speed = deg2rad(64) # degrees per second
	
	# output here
	var velocity = Vector2(0, 0)
	var rotation = 0
	
	func _init(o):
		owner = o
	
	func update():
		var tr = target.get_ref()
		if tr:
			# update velocity
			velocity = tr.get_global_pos() - owner.get_global_pos()
			# update orientation
			#if velocity.length() > 0:
			#	rotation = clamp(velocity.normalized().angle(), -max_rot_speed, max_rot_speed)
		else:
			target = null
	
	func set_target(t):
		target = weakref(t)
		
class Arrive:
	
	var owner
	var target
	var velocity = Vector2(0, 0)
	var rotation = 0
	
	# custom
	var radius = 0
	var time_to_target = 1
	
	func _init(o, r):
		owner = o
		radius = r
	
	func update():
		var tr = target.get_ref()
		if tr:
			if velocity.length() < radius:
				velocity.x = 0
				velocity.y = 0
			velocity /= time_to_target
		else:
			target = null
	
	func set_target(t):
		target = weakref(t)

class Flee:
	func init():
		pass
		
	func get_steering():
		pass

func _ready():
	pass
