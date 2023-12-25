extends CharacterBody2D

var speed = 150
var motion = Vector2.ZERO
var dodgeDistance = 1000
var dodgeSpeed = 300
@onready var animator = $AnimationPlayer
@onready var tree = $AnimationTree
var input_vector = Vector2.ZERO
@export var busy = false

var attackSwitch = false

func _ready():
	busy = false
	tree.active = true
	
func _physics_process(delta):
	if !busy: move(delta)
	updateAnimParameters()
	set_velocity(motion)
	move_and_slide()
	print(tree["parameters/conditions/attackB"])
	
	if Input.is_action_just_pressed("dodge"):
		if motion == Vector2(0,0): dodge(Vector2(transform.x.x, 0))
		else: dodge(input_vector)
	
	if Input.is_action_just_pressed("attack"):# && tree["parameters/conditions/attackA"] == tree["parameters/conditions/attackB"] == false:
		attackSwitch = !attackSwitch
		if attackSwitch == false: tree["parameters/conditions/attackA"] = true 
		elif attackSwitch == true: tree["parameters/conditions/attackB"] = true 
		tree["parameters/conditions/idle"] = false

func dodge(direction):
	speed = 300
	velocity = dodgeSpeed * direction
	animator.play("Dodge")

func move(_delta):
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	motion = velocity
	motion = input_vector * speed

func updateAnimParameters():
	if !busy:
		if motion.x > 0: transform.x.x = 1
		elif motion.x < 0: transform.x.x = -1
	if velocity == Vector2.ZERO:
		tree["parameters/conditions/idle"] = true
		tree["parameters/conditions/isMoving"] = false
	else:
		tree["parameters/conditions/idle"] = false
		tree["parameters/conditions/isMoving"] = true
