extends Area2D

func _ready():
	get_node("CollisionShape2D").set_pos(Vector2(get_tree().get_root().get_rect().size.x, 561))
