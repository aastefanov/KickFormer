extends Node2D

export (PackedScene) var platform = null
export (PackedScene) var levelScene = null
var spawnTime = 0;
const spawncount = 1
onready var database = get_node("Database")
var player_id

func _ready():
	randomize()
	database.register("Nikolay")
	database.seed_stats()
	player_id = database.get_player_by_name("Nikolay")
	database.set_high_score(0, player_id)
	get_node("music").play("hard")
	set_fixed_process(true)
	
	
func _fixed_process(delta):

	get_node("CanvasLayer/Score").set_text(str(get_node("/root/globals").currentLevel + 1))
	if (spawnTime >= 2):
		 #platformSpawner()
		 spawnTime = 0
	if (Input.is_action_pressed("exit")):
		get_tree().quit()
	spawnTime += delta;

func generateNextLevel():
	var level = levelScene.instance()
	level.set_name("level" + str(get_node("/root/globals").currentLevel + 1))
	level.set_pos(Vector2((get_node("/root/globals").currentLevel + 1) * get_tree().get_root().get_rect().size.x, 0))
	get_node("stages").add_child(level)