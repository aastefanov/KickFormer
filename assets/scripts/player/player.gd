extends KinematicBody2D

const GRAVITY = 500.0
const WALK_SPEED = 200
const jump_strenght = 350
const JUMP_DELAY = 0.4

var velocity = Vector2()
var jumps = 0

var timesincelastjump = 0

onready var jumpcast = get_node("RayCast2D")

func _fixed_process(delta):
	movement(delta)


func movement(var delta):
	velocity.y += delta * GRAVITY
	timesincelastjump += delta
	if (Input.is_action_pressed("ui_left")):
		velocity.x = -WALK_SPEED
	elif (Input.is_action_pressed("ui_right")):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0
	if (Input.is_action_pressed("ui_up") && jumps < 1 && timesincelastjump > JUMP_DELAY):
		timesincelastjump = 0
		jumps += 1
		if (jumps == 1):
			velocity.y = 0
		velocity.y -= jump_strenght
	if (jumpcast.is_colliding() && !jumpcast.get_collider().is_in_group("player")):
		jumps = 0
	var motion = velocity * delta
	
	move(motion)
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
func _ready():
    set_fixed_process(true)