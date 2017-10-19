extends KinematicBody2D

var angle 
export (int) var speed = 1500
export (int) var damage = 20

func _ready():
	pass
	
func shoot(var pos, var _angle):
	set_pos(pos)
	
	angle = deg2rad(_angle)
	set_rot(-angle)
	set_fixed_process(true)
	
func _fixed_process(delta):
	move(Vector2(cos(angle) * speed * delta, sin(angle) * speed * delta))
	if is_colliding():
		var collider = get_collider()
		if !collider.is_in_group("enemies") && !collider.is_in_group("player"):
			queue_free()

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()
