extends Node

var db = SQLite.new();

func _ready():
	# Open SQL
	if db.open("user://data.sqlite3") != db.SQLITE_OK:
		print("ERR: ", db.get_errormsg())
		return
	
	migrate_tables()
	seed_stats()

#	print(get_high_score(get_player_by_name("geiorgii")))
#	var id = register("geiorgii")
#	var statid = get_stat_by_name("jump_start")
#	set_value_to_stat(statid, 69, id)
#	set_stat_goal(statid, 42, id)
#	add_value_to_stat(statid, -5, id)
#	print(get_player_stat(statid, id))

### Seeds
func migrate_tables():
	db.query("""
		CREATE TABLE IF NOT EXISTS players 
		(id INTEGER PRIMARY KEY AUTOINCREMENT, 
		high_score INTEGER DEFAULT 0, 
		name VARCHAR(50) UNIQUE ON CONFLICT IGNORE);
		""")
	db.query("""
		CREATE TABLE IF NOT EXISTS stats 
		(id INTEGER PRIMARY KEY AUTOINCREMENT, 
		name VARCHAR(50) UNIQUE);
		""")
	db.query("""
		CREATE TABLE IF NOT EXISTS player_stats 
		(id INTEGER PRIMARY KEY AUTOINCREMENT, 
		player_id INTEGER, 
		stat_id INTEGER, 
		weigth INTEGER DEFAULT 0, 
		goal DOUBLE DEFAULT 50.0,
		value DOUBLE DEFAULT 50.0,
		FOREIGN KEY(player_id) REFERENCES players(id), 
		FOREIGN KEY(stat_id) REFERENCES stats(id),
		UNIQUE(player_id, stat_id) ON CONFLICT IGNORE);
		""")

func seed_stats():
	db.query("INSERT INTO stats (name) values ('jump_start')")

### Players
func register(name):
	db.query("INSERT INTO players (name) VALUES ('"+name+"');")
	var id = get_player_by_name(name)
	db.query("INSERT INTO player_stats (stat_id, player_id) SELECT id, '"+str(id)+"' FROM stats;")
	return id

func get_player_by_name(name):
	for row in db.fetch_array("SELECT id FROM players WHERE name='"+name+"' LIMIT 1;"):
		return row["id"]

func set_high_score(high_score, player_id):
	db.query("UPDATE players SET high_score='"+str(high_score)+"' WHERE id='"+str(player_id)+"';")

func get_high_score(player_id):
	for row in db.fetch_array("SELECT high_score FROM players WHERE id='"+str(player_id)+"' LIMIT 1;"):
		return row["high_score"]
### Stats
func get_stat_by_name(name):
	for row in db.fetch_array("SELECT id FROM stats WHERE name='"+name+"' LIMIT 1;"):
		return row["id"]


### Player Stats
func get_player_stat(stat_id, player_id):
	for row in db.fetch_array("SELECT value, weigth, goal FROM player_stats WHERE player_id='"+str(player_id)+"' AND stat_id='"+str(stat_id)+"' LIMIT 1;"):
		return row
	return null

func set_value_to_stat(stat_id, value, player_id):
	db.query("UPDATE player_stats SET value='" + str(value) + "', weigth = weigth + 1 WHERE player_id='"+str(player_id)+"' AND stat_id='"+str(stat_id)+"';")

#func add_value_to_stat(stat_id, value, player_id):
#	db.query("UPDATE player_stats SET value = value + '" + str(value) + "', weigth = weigth + 1 WHERE player_id='"+str(player_id)+"' AND stat_id='"+str(stat_id)+"';")
#	print(db.get_errormsg())

func set_stat_goal(stat_id, goal, player_id):
	db.query("UPDATE player_stats SET goal='"+str(goal)+"' WHERE stat_id='"+str(stat_id)+"' AND player_id='"+str(player_id)+"';")

func _on_Node2D_exit_tree():
	db.close()
