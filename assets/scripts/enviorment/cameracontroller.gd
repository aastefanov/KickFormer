extends Camera2D

var goal = 0
var time = 0
var current_pos = 0

func _ready():
	set_zoom(get_node("/root/globals").ratio)
	set_fixed_process(false)


func _on_finishPoint_body_enter( body ):
	if(body.is_in_group("player")):
		get_parent().generateNextLevel()
		time = 0
		get_node("/root/globals").currentLevel += 1
		goal = get_parent().get_node("stages/level" + str(get_node("/root/globals").currentLevel) + "/Position2D").get_global_pos().x
		#goal += 190
		get_parent().get_node("finishPoint").translate(Vector2(get_tree().get_root().get_rect().size.x, 0))
		set_fixed_process(true)

func _fixed_process(delta):
	current_pos = get_global_pos().x
	
	var pos = lerp(current_pos, goal, time)
	time += delta / 20
	set_global_pos(Vector2(pos, get_global_pos().y));
	#print(get_glov_pos().x)
	