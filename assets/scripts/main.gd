extends Node2D

export (PackedScene) var platform = null
var spawnTime = 0;
const spawncount = 1
var score = 0
onready var database = get_node("Database")
var player_id

func _ready():
	randomize()
	database.register("Nikolay")
	database.seed_stats()
	player_id = database.get_player_by_name("Nikolay")
	database.set_high_score(0, player_id)
	
	#get_node("StreamPlayer").play("hard")
	#platformSpawner()
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	score += 0.2

	get_node("CanvasLayer/Label").set_text(str(round(score)))
	if (spawnTime >= 2):
		 #platformSpawner()
		 spawnTime = 0
	if (Input.is_action_pressed("exit")):
		get_tree().quit()
	spawnTime += delta;


func spawn_platform(var pos, var deviation):
	var spawnedPlatform = platform.instance()
	spawnedPlatform.set_pos(pos)
	#spawnedPlatform.speed = spawnedPlatform.speed * deviation
	add_child(spawnedPlatform)
	
func platformSpawner():
	var spawnpos = Vector2(get_viewport().get_rect().size.x,rand_range(get_viewport().get_rect().size.y / 3, get_viewport().get_rect().size.y - (get_viewport().get_rect().size.y / 3)))
	var stat_id = database.get_stat_by_name("jump_start")
	var statvalue = database.get_player_stat(stat_id, player_id)
	var deviation = (100 + (statvalue["value"] - statvalue["goal"])) / 100
	spawn_platform(spawnpos,  deviation )
	
	