extends CharacterBody2D

var speed = 75
var motion = Vector2.ZERO
var canIdle = false
@onready var animator = $AnimationPlayer
@onready var tree = $AnimationTree
var input_vector = Vector2.ZERO
@export var attackWindow = false

func _ready():
	tree.active = true
	attackWindow = false
	
func _process(_delta):
	updateAnimParameters()

func _physics_process(_delta):
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	motion = input_vector * speed
	
	set_velocity(motion)
	move_and_slide()
	motion = velocity

func updateAnimParameters():
	if motion == Vector2.ZERO:
		tree["parameters/conditions/idle"] = true
		tree["parameters/conditions/isMoving"] = false
	else:
		tree["parameters/conditions/idle"] = false
		tree["parameters/conditions/isMoving"] = true
		if motion.x > 0: 
			$Sprite2D.flip_h = false
			$Hitbox/CollisionShape2D.position.x = 20
		if motion.x < 0: 
			$Sprite2D.flip_h = true
			$Hitbox/CollisionShape2D.position.x = -20
	if Input.is_action_just_pressed("attack"):
		tree["parameters/conditions/attack"] = true
		tree["parameters/conditions/idle"] = false
		if attackWindow == true:
			if animator.current_animation == "Attack 1":
				animator.play("Attack 2")
			if animator.current_animation == "Attack 2":
				animator.play("Attack 1")
			tree["parameters/conditions/idle"] = false
	else:
		tree["parameters/conditions/attack"] = false
		#tree["parameters/conditions/combo"] = false
