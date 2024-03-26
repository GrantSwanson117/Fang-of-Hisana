extends State

@onready var camera = owner.owner.get_node("Fang/Camera2D")

signal hitWall

var chargeDirection
var currentCharges: int
var chargeCollide: bool = false
@onready var durationTimer = owner.get_node("ChargeDurationTimer")

func _ready():
	connect("hitWall", chargeEnd)

func enter():
	owner.get_node("AnimationPlayer").play("Charge")
	owner.emit_signal("moveTrue")
	owner.get_node("Hitbox/CollisionPolygon2D").disabled = false
	owner.get_node("Hitbox/CollisionShape2D").disabled = true
	owner.damage += owner.chargeBonus
	currentCharges = 0
	charge()

func _physics_process(_delta):
	var collision = bigGuy.move_and_collide(bigGuy.direction.normalized() * bigGuy.chargeSpeed)
	if collision: emit_signal("hitWall")
	if owner.velocity == Vector2.ZERO: chargeEnd()

func charge():
	owner.get_node("SFX/GallopSFX").play()
	bigGuy.get_node("Hitbox").look_at(player.global_position)
	bigGuy.baseSpeed = bigGuy.chargeSpeed
	bigGuy.velocity = bigGuy.direction.normalized() * bigGuy.chargeSpeed
	if bigGuy.direction.x > 0: bigGuy.find_child("Sprite2D").flip_h = true
	else: bigGuy.find_child("Sprite2D").flip_h = false
	durationTimer.start()

func chargeEnd():
	owner.get_node("SFX/GallopSFX").playing = false
	durationTimer.stop()
	print("current charges: ",currentCharges)
	camera.shake(0.2, 2)
	bigGuy.direction =  player.global_position - bigGuy.global_position
	currentCharges += 1
	if currentCharges < bigGuy.maxCharges:
		await(get_tree().create_timer(0.5)).timeout
		charge()
	if currentCharges >= bigGuy.maxCharges:
		set_physics_process(false)
		await(get_tree().create_timer(1)).timeout
		get_parent().changeState("Follow")
		owner.damage -= owner.chargeBonus

func _on_hurtbox_body_entered(body):
	durationTimer.stop()
	if body.is_in_group("world"):
		owner.get_node("SFX/SlamSFX").play()
		chargeEnd()

func _on_charge_duration_timer_timeout():
	owner.velocity = Vector2.ZERO
	chargeEnd()
