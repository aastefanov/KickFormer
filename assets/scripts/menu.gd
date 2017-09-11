extends Control

func _ready():	
	pass

func _on_Button_pressed():
	print(get_node("LineEdit").get_text())
	get_tree().change_scene("res://assets/scenes/main.tscn")
