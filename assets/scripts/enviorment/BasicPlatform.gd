extends StaticBody2D

var speed = 300;

func _ready():
	randomize()
	var k = rand_range(0, 2)
	k = int(k)
	var textr = load("res://assets/sprites/enviorment/platforms/platform" + str(k) + "_test.png")
	#get_node("Sprite").set_texture(textr)
	set_fixed_process(true)
	
func get_speed():
	return speed

func _fixed_process(delta):
	translate(Vector2(-speed * delta, 0))


func _on_VisibilityNotifier2D_exit_screen():
	queue_free()
