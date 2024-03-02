extends Entity

@export var speed: int
@export var fireballSpeed: int = 0
var motion = Vector2.ZERO
@onready var animator = $AnimationPlayer
@onready var tree = $AnimationTree
var input_vector = Vector2.ZERO
@export var busy: bool = false
@export var canAction: bool = true

var canCast = true
var Fireball = preload("res://scenes/fireball.tscn")
var Dust = preload("res://scenes/dust.tscn")

var attackSwitch = false

func _ready():
	health = maxHealth
	$Hurtbox/CollisionShape2D.disabled = false
	busy = false
	canAction = true
	tree.active = true
	speed = 150
	fireballSpeed = 800

func _physics_process(delta):
	if !busy: move(delta)
	updateAnimParameters()
	set_velocity(motion)
	move_and_slide()
	
	if Input.is_action_just_pressed("dodge") and velocity != Vector2.ZERO and canAction:
		dodge(input_vector)
	if Input.is_action_just_pressed("fireball") and canAction and canCast:
		shootFireball((get_global_mouse_position() - global_position).normalized())
		await(get_tree().create_timer(0.13)).timeout
		shootFireball((get_global_mouse_position() - global_position).normalized().rotated(deg_to_rad(-8)))
		await(get_tree().create_timer(0.13)).timeout
		shootFireball((get_global_mouse_position() - global_position).normalized().rotated(deg_to_rad(8)))
		$CastTimer.start()
	
	
	if Input.is_action_just_pressed("attack") and !busy:
		attackSwitch = !attackSwitch
		if attackSwitch == false: tree["parameters/conditions/attackA"] = true 
		elif attackSwitch == true: tree["parameters/conditions/attackB"] = true 
		tree["parameters/conditions/idle"] = false
		
	if Input.is_action_just_pressed("repulse") and !busy:
		print("Repulse!")
func dodge(direction):
	speed = 300
	tree["parameters/conditions/dodge"] = true
	velocity = speed * direction
	var tween = create_tween()
	tween.tween_property(self, "speed", baseSpeed, 0.3)
	canAction = false
	$DodgeTimer.start()
	var dustInstance = Dust.instantiate()
	get_tree().current_scene.add_child(dustInstance)
	dustInstance.global_position = $DustPosition.global_position
	dustInstance.scale.x = -scale.x
	dustInstance.rotation = global_rotation
	dustInstance.emitting = true

func _on_dodge_timer_timeout(): canAction = true

func move(_delta):
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	motion = input_vector * speed

func shootFireball(dir: Vector2):
	var fireballInstance = Fireball.instantiate()
	get_tree().current_scene.add_child(fireballInstance)
	fireballInstance.position = self.global_position
	fireballInstance.linear_velocity = dir * fireballSpeed
	animator.play("Magic")
	canCast = false
	
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

func die():
	tree.active = false
	busy = true
	animator.play("Die")
	motion = Vector2.ZERO
	
func _on_hitbox_area_entered(area):
	if $Collider.owner != area.owner:
		damage = randi_range(minDamage, maxDamage)
		dealDamage(damage, area.get_parent())

func _on_cast_timer_timeout():
	canCast = true
