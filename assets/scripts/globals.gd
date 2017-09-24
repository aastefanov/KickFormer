extends Node

var currentLevel = 0
var ratio = 1
export (int) var desiredWidth = 1920
export (int) var desiredHeight = 1080

func _ready():
	var currentScreenSize = get_tree().get_root().get_rect().size
	var desiredSize = Vector2(desiredWidth, desiredHeight)
	ratio = currentScreenSize / desiredSize
	
