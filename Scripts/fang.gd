extends Entity

@export var speed: int
@export var fireballSpeed: int = 0
@export var maxMagic: int
var magic: float
var magicCost: int = 10
var motion = Vector2.ZERO
@onready var animator = $AnimationPlayer
@onready var tree = $AnimationTree
var input_vector = Vector2.ZERO
@export var busy: bool = false
@export var canAction: bool = true

var canCast: bool = true
var Fireball = preload("res://scenes/fireball.tscn")
var Dust = preload("res://scenes/dust.tscn")

var attackSwitch = false

func _ready():
	$CastTimer.stop()
	$UI.hide()
	health = maxHealth
	magic = maxMagic
	$Hurtbox/CollisionShape2D.disabled = false
	$UI/HealthBar.max_value = health
	$UI/MagicBar.max_value = magic
	busy = false
	tree["parameters/conditions/isCasting"] = false 
	canAction = true
	tree.active = true
	speed = 150
	fireballSpeed = 500
	set_physics_process(false)

func _physics_process(delta):
	$UI/HealthBar.value = health
	$UI/MagicBar.value = magic
	if magic < maxMagic: magic += 0.015
	if !busy: move(delta)
	updateAnimParameters()
	set_velocity(motion)
	move_and_slide()
	
	if Input.is_action_just_pressed("dodge") and velocity != Vector2.ZERO and canAction:
		dodge(input_vector)
	
	if Input.is_action_just_pressed("fireball") and canAction and canCast and magic > 30:
		$SFX/FireballSFX.play()
		shootFireball((get_global_mouse_position() - global_position).normalized())
		magic -= 10
		await(get_tree().create_timer(0.13)).timeout
		$SFX/FireballSFX2.play()
		shootFireball((get_global_mouse_position() - global_position).normalized().rotated(deg_to_rad(-8)))
		magic -= 10
		await(get_tree().create_timer(0.13)).timeout
		$SFX/FireballSFX3.play()
		shootFireball((get_global_mouse_position() - global_position).normalized().rotated(deg_to_rad(8)))
		magic -= 10
		$CastTimer.start()
	
	
	if Input.is_action_just_pressed("attack") and !busy:
		attackSwitch = !attackSwitch
		if attackSwitch == false: tree["parameters/conditions/attackA"] = true 
		elif attackSwitch == true: tree["parameters/conditions/attackB"] = true 
		tree["parameters/conditions/idle"] = false

func dodge(direction):
	$SFX/DodgeSFX.play()
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
	get_parent().get_node("UI").emit_signal("playerDeath")
	visible = false
	tree.active = false
	busy = true
	$SFX/DeathSFX.play()
	$SFX/HitSFX.play()
	motion = Vector2.ZERO
	get_tree().paused = true
	
func _on_hitbox_area_entered(area):
	if $Collider.owner != area.owner:
		damage = randi_range(minDamage, maxDamage)
		dealDamage(damage, area.get_parent())

func _on_cast_timer_timeout():
	canCast = true
