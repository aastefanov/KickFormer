extends KinematicBody2D

const GRAVITY = 1000

export (int) var maxHealth = 100
var currentHealth = 100

func _ready():
	currentHealth = maxHealth
	set_fixed_process(true)

func _fixed_process(delta):
	get_node("health").set_text(str(currentHealth))
	move(Vector2(0, GRAVITY * delta))

func _on_hitbox_body_enter( body ):
	if body.is_in_group("bullets"):
		currentHealth -= body.damage
		body.queue_free()
		if currentHealth <= 0:
			queue_free()
