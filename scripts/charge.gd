extends State

signal hitWall

var chargeDirection
var currentCharges: int
var chargeCollide: bool = false
@onready var camera = owner.owner.get_node("Fang").find_child("Camera2D")

func _ready():
	connect("hitWall", chargeEnd)

func enter():
	currentCharges = 0
	charge()

func _physics_process(_delta):
	var collision = bigGuy.move_and_collide(bigGuy.direction.normalized() * bigGuy.chargeSpeed)
	if collision: emit_signal("hitWall")
	if owner.velocity == Vector2.ZERO: chargeEnd()

func charge():
	bigGuy.get_node("Hitbox").look_at(player.global_position)
	bigGuy.baseSpeed = bigGuy.chargeSpeed
	bigGuy.velocity = bigGuy.direction.normalized() * bigGuy.chargeSpeed
	if bigGuy.direction.x > 0: bigGuy.find_child("Sprite2D").flip_h = true
	else: bigGuy.find_child("Sprite2D").flip_h = false

func chargeEnd():
	print("current charges: ",currentCharges)
	camera.shake(0.2, 2)
	bigGuy.direction =  player.global_position - bigGuy.global_position
	currentCharges += 1
	if currentCharges < bigGuy.maxCharges:
		await(get_tree().create_timer(0.5)).timeout
		charge()
	if currentCharges >= bigGuy.maxCharges:
		await(get_tree().create_timer(1)).timeout
		get_parent().changeState("Follow")


func _on_hurtbox_body_entered(body):
	if body.is_in_group("world"):
		print("bals")
		var push_direction = -bigGuy.direction.normalized()
		var push_strength = 10.0
		var push_velocity = -push_direction * push_strength
		bigGuy.velocity += push_velocity
		chargeEnd()