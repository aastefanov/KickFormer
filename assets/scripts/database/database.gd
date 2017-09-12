	extends Node
	
var db = SQLite.new();


func _ready():
	# Open SQL
	if db.open("user://data.sql") != db.SQLITE_OK:
		print("ERR: ", db.get_errormsg());
		return;

	# Create database if not exists
	db.query("CREATE TABLE IF NOT EXISTS players (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);");
	db.query("CREATE TABLE IF NOT EXISTS stats (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);");
	
	db.close();
