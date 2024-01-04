extends CharacterBody2D

@export var speed: int
@export var baseSpeed: int = 150
var motion = Vector2.ZERO
@onready var animator = $AnimationPlayer
@onready var tree = $AnimationTree
var input_vector = Vector2.ZERO
@export var busy: bool
@export var canDodge: bool

var attackSwitch = false

func _ready():
	busy = false
	canDodge = true
	tree.active = true
	speed = 150
	
func _physics_process(delta):
	if !busy: move(delta)
	updateAnimParameters()
	set_velocity(motion)
	move_and_slide()
	
	if Input.is_action_just_pressed("dodge") and velocity != Vector2.ZERO and canDodge:
		dodge(input_vector)
	
	if Input.is_action_just_pressed("attack") and !busy:
		attackSwitch = !attackSwitch
		if attackSwitch == false: tree["parameters/conditions/attackA"] = true 
		elif attackSwitch == true: tree["parameters/conditions/attackB"] = true 
		tree["parameters/conditions/idle"] = false


func dodge(direction):
	speed = 300
	tree["parameters/conditions/dodge"] = true
	velocity = speed * direction
	var tween = create_tween()
	tween.tween_property(self, "speed", baseSpeed, 0.3)
	canDodge = false
	$DodgeTimer.start()

func _on_dodge_timer_timeout(): canDodge = true

func move(_delta):
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	motion = velocity
	motion = input_vector * speed

func updateAnimParameters():
	if !busy:
		if motion.x > 0: 
			transform.x.x = 1
		elif motion.x < 0: 
			transform.x.x = -1
	if velocity == Vector2.ZERO:
		tree["parameters/conditions/idle"] = true
		tree["parameters/conditions/isMoving"] = false
	else:
		tree["parameters/conditions/idle"] = false
		tree["parameters/conditions/isMoving"] = true


