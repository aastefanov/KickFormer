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

var direction = false 

onready var jumpcast = get_node("jumpcast")
onready var groundcheck = get_node("groundcheck")
onready var anim = get_node("animation")
onready var rightRaycast = get_node("Right")
onready var leftRaycast = get_node("Left")
onready var database = get_parent().get_node("Database")



func _fixed_process(delta):
	movement(delta)


func movement(var delta):
	velocity.y += delta * GRAVITY

	timesincelastjump += delta
	if (Input.is_action_pressed("ui_left")):
		velocity.x = -WALK_SPEED
		direction = true 
		anim.set_flip_h(direction)
		walking = true
	elif (Input.is_action_pressed("ui_right")):
		velocity.x =  WALK_SPEED
		direction = false
		anim.set_flip_h(direction)
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
		if (jumps == 0):
			if (groundcheck.get_collider() != null):
				var lenght = groundcheck.get_collider().get_node("Sprite").get_texture().get_size().x * groundcheck.get_collider().get_scale().x
				var startpos = groundcheck.get_collider().get_global_pos().x - lenght / 2	
				var collisionpoint 
				if (get_global_pos().x < groundcheck.get_collider().get_global_pos().x):
					
					collisionpoint = rightRaycast.get_collision_point().x
					#print (collisionpoint)
				else:
					collisionpoint = leftRaycast.get_collision_point().x
				var percent = ((collisionpoint - startpos)/lenght) * 100
				percent = clamp(percent, 1, 100)
				modify_jump_value(percent)
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
		velocity = n.slide(velocity)
		
		move(motion)
func modify_jump_value(var percent):
	var jump_start_id = database.get_stat_by_name("jump_start")
	var player_id = get_parent().player_id 
	var jump_start_row = database.get_player_stat(jump_start_id, player_id);
	var insert_value = (jump_start_row["value"] * jump_start_row["weigth"] + percent) / (jump_start_row["weigth"] + 1)
	database.set_value_to_stat(jump_start_id, insert_value, player_id)
	#print(database.get_player_stat(jump_start_id, player_id))
func _ready():
	jumpcast.add_exception(self)
	rightRaycast.add_exception(self)
	leftRaycast.add_exception(self)
	set_fixed_process(true)