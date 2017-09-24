extends Node2D

export (PackedScene) var platform = null
var spawnTime = 0;

func _ready():
	
	set_fixed_process(true)
	#spawnPlatform(Vector2(get_viewport().get_rect().size.x,get_viewport().get_rect().size.y/2))
	
func _fixed_process(delta):
	if (spawnTime >= 3):
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
	spawnPlatform(Vector2(get_viewport().get_rect().size.x,get_viewport().get_rect().size.y/2))

	