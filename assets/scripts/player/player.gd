extends KinematicBody2D

const GRAVITY = 1000.0
const WALK_SPEED = 320
const jump_strenght = 650
const JUMP_DELAY = 0.35

var velocity = Vector2()
var jumps = 0


var walking = false
var jumping = false 
var timesincelastjump = 0

onready var jumpcast = get_node("jumpcast")
onready var grouncheck = get_node("groundcheck")
onready var anim = get_node("animation")

func _fixed_process(delta):
	movement(delta)


func movement(var delta):
	velocity.y += delta * GRAVITY

	timesincelastjump += delta
	if (Input.is_action_pressed("ui_left")):
		velocity.x = -WALK_SPEED

		anim.set_flip_h(true)
		walking = true
	elif (Input.is_action_pressed("ui_right")):
		velocity.x =  WALK_SPEED
		anim.set_flip_h(false)
		walking = true
	else:
		walking = false
		if (anim.get_animation() == "walking"):
			anim.play("idle")
		velocity.x = 0
	if (Input.is_action_pressed("ui_up") && jumps < 2 && timesincelastjump > JUMP_DELAY):
		timesincelastjump = 0
		jumping = true
		anim.play("jump")
		anim.set_frame(0)
#		if (jumps == 0):
#			if (grouncheck.get_collider() != null):
		#		var lenght = grouncheck.get_collider().get_node("Sprite").get_texture().get_size().x / 2
		#		var startpos = grouncheck.get_collider().get_node("Sprite").get_global_pos().x - lenght / 2
		#		var collisionpoint = grouncheck.get_collision_point().x
		#		var percent = ((collisionpoint - startpos)/lenght) * 100
		#		print(percent)
		jumps += 1
		velocity.y = -jump_strenght
	if (walking && !jumping):
		anim.play("walking")
	if (!walking && !jumping):
		anim.play("idle")
	var motion = velocity * delta
	
	
	
	move(motion)
	if (is_colliding()):
		if (!walking):
			translate(Vector2(-get_collider().get_speed() * delta, 0))
		if (jumpcast.is_colliding()):	
			jumps = 0
		jumping = false
		var n = get_collision_normal()
		motion = n.slide(motion)
		if (Input.is_action_pressed("ui_select")):
			print(motion)
		velocity = n.slide(velocity)
		
		move(motion)
		
func _ready():
	jumpcast.add_exception(self)
	set_fixed_process(true)