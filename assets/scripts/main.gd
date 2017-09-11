extends Node2D

export (PackedScene) var platform = null
var spawnTime = 0;
const spawncount = 1

func _ready():
	randomize()

	platformSpawner()
	set_fixed_process(true)
func _fixed_process(delta):
	if (spawnTime >= 1):
		 platformSpawner()
		 spawnTime = 0
	if (Input.is_action_pressed("exit")):
		get_tree().quit()
	spawnTime += delta;


func spawnPlatform(var pos):
	var spawnedPlatform = platform.instance()
	spawnedPlatform.set_pos(pos)
	add_child(spawnedPlatform)
	
func platformSpawner():
	spawnPlatform(Vector2(get_viewport().get_rect().size.x,rand_range(get_viewport().get_rect().size.y / 4, get_viewport().get_rect().size.y - (get_viewport().get_rect().size.y / 4))))
	

	