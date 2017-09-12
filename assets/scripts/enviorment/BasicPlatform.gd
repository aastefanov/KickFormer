extends StaticBody2D

const SPEED = 300;

func _ready():
	randomize()
	var k = rand_range(1, 4)
	k = int(k)
	var textr = load("res://assets/sprites/enviorment/platforms/platform" + str(k) + ".png")
	get_node("Sprite").set_texture(textr)
	set_fixed_process(true)
	
func get_speed():
	return SPEED

func _fixed_process(delta):
	translate(Vector2(-SPEED * delta, 0))


func _on_VisibilityNotifier2D_exit_screen():
	queue_free()
