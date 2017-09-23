extends KinematicBody2D

var angle 
export (int) var speed = 1000

func _ready():
	pass
	
func shoot(var pos, var _angle):
	set_pos(pos)
	
	angle = deg2rad(_angle)
	set_rot(angle)
	set_fixed_process(true)
	
func _fixed_process(delta):
	move(Vector2(cos(angle) * speed * delta, sin(angle) * speed * delta))
	if (is_colliding()):
		queue_free()