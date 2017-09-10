extends StaticBody2D

const SPEED = 200;

func _ready():
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	translate(Vector2(-SPEED * delta, 0))


func _on_VisibilityNotifier2D_exit_screen():
	translate(Vector2(get_viewport().get_rect().size.x, 0))
