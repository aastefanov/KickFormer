extends KinematicBody2D

const GRAVITY = 1000.0
const WALK_SPEED = 320
const jump_strenght = 650
const JUMP_DELAY = 0.35
const SHOOT_DELAY = 0.2

var velocity = Vector2()
var jumps = 0

var lastShot = 0

var walking = false
var jumping = false 
var timesincelastjump = 0

var direction = false 

onready var jumpcast = get_node("jumpcast")
onready var groundcheck = get_node("groundcheck")
onready var anim = get_node("body/animation")
onready var rightRaycast = get_node("Right")
onready var leftRaycast = get_node("Left")
onready var database = get_parent().get_node("Database")
onready var leftShot = get_node("leftShot")
onready var rightShot = get_node("rightShot")
onready var leftArm = get_node("body/arm-left")
onready var rightArm = get_node("body/arm-right")

export (PackedScene) var bulletScene = null

var currentArm
var armAngle = 0


func shoot():
	direction = get_global_mouse_pos() < get_pos() 
	moveArm()
	armAngle = findAngle(currentArm.get_node("shoulder").get_global_pos(),get_global_mouse_pos())
	armAngle -= 180
	if armAngle < 0:
		armAngle = 360 + armAngle 
	if !direction:
		armAngle = clamp(armAngle, 225, 315) 
	else: 
		armAngle = clamp(armAngle, 45, 135) 
	
	armAngle = deg2rad(-armAngle)

	currentArm.set_rot(armAngle)

	var shootingPoint = currentArm.get_node("shootingPosition").get_global_pos()
	var bullet = bulletScene.instance()
	#var shootAngle = findAngle(shootingPoint,get_global_mouse_pos())
	var shootAngle = rad2deg(armAngle) - 90
	if shootAngle < 0:
		shootAngle = 360 + shootAngle
#	if direction:
#		shootAngle = clamp(armAngle, 225, 315) 
#	else: 
#		shootAngle = clamp(armAngle, 45, 135) 
	bullet.shoot(shootingPoint,-shootAngle)
	get_parent().add_child(bullet)

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_LEFT && event.pressed && lastShot <= 0:
			shoot()
			lastShot = SHOOT_DELAY

func _fixed_process(delta):
	lastShot -= delta
	#var oDir = direction
	#direction = get_global_mouse_pos() < get_pos() 
	#if oDir != direction:
		#moveArm()
	anim.set_flip_h(direction)
#	if Input.is_action_pressed("shoot") && lastShot <= 0:

	movement(delta)
	

func moveArm():
	if direction:
		leftArm.hide()
		rightArm.show()
		currentArm = rightArm
		armAngle = rad2deg(armAngle)
		armAngle = 360 - armAngle
		armAngle = deg2rad(armAngle)
		get_node("body/arm-right").set_rot(armAngle)
	else:
		rightArm.hide()
		leftArm.show()
		currentArm = leftArm
		armAngle = rad2deg(armAngle)
		armAngle = 360 - armAngle
		armAngle = deg2rad(armAngle)
		get_node("body/arm-left").set_rot(armAngle)


func movement(var delta):
	velocity.y += delta * GRAVITY

	timesincelastjump += delta
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
		if (!direction):
			get_node("body/arm-right").set_rot(armAngle)
			direction = true 
			currentArm = leftArm
			
			moveArm()
		anim.set_flip_h(direction)
		walking = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
		if (direction):
			get_node("body/arm-right").set_rot(armAngle) 
			direction = false
			currentArm = rightArm
			moveArm()
		anim.set_flip_h(direction)
		walking = true
	else:
		walking = false
		if anim.get_animation() == "walking":
			anim.play("idle")
		velocity.x = 0
	if Input.is_action_pressed("ui_up") && jumps < 2 && timesincelastjump > JUMP_DELAY:
		timesincelastjump = 0
		jumping = true
		#anim.play("jump")
		#anim.set_frame(0)
		if jumps == 0:
			anim.set_frame(0)
			anim.stop()
			if groundcheck.get_collider() != null:
				#var lenght = groundcheck.get_collider().get_node("Sprite").get_texture().get_size().x * groundcheck.get_collider().get_scale().x
				#var startpos = groundcheck.get_collider().get_global_pos().x - lenght / 2	
				#var collisionpoint 
				#if get_global_pos().x < groundcheck.get_collider().get_global_pos().x:
					
				#	collisionpoint = rightRaycast.get_collision_point().x
				#else:
				#	collisionpoint = leftRaycast.get_collision_point().x
				#var percent = ((collisionpoint - startpos)/lenght) * 100
				#percent = clamp(percent, 1, 100)
				#modify_jump_value(percent)
				pass 
		jumps += 1
		velocity.y = -jump_strenght
	if walking && !jumping:
		anim.play("walking")
	if !walking:
		anim.play("idle")
	var motion = velocity * delta
	
	move(motion)
	if is_colliding():
		if jumpcast.is_colliding():	
			jumps = 0
		jumping = false
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		
		move(motion)

func modify_jump_value(var percent):
	var jump_start_id = database.get_stat_by_name("jump_start")
	var player_id = get_parent().player_id 
	var jump_start_row = database.get_player_stat(jump_start_id, player_id)
	var insert_value = (jump_start_row["value"] * jump_start_row["weigth"] + percent) / (jump_start_row["weigth"] + 1)
	database.set_value_to_stat(jump_start_id, insert_value, player_id)

func findAngle(var point1, var point2):
	var theta = atan2(point2.x - point1.x, point1.y - point2.y)
	if theta < 0:
		theta += 2*PI
	return rad2deg(theta)

func _ready():
	jumpcast.add_exception(self)
	rightRaycast.add_exception(self)
	leftRaycast.add_exception(self)
	moveArm()
	set_fixed_process(true)
	set_process_input(true)