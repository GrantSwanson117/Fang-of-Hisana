extends State

var pyresInProgress: bool = false
var elapsed_time: int = 0
var dirToPoint: Vector2
var directionFacing: int = 1
@export var maxErupts: int
var curErupts: int = 1
var timerRunning: bool = false

@onready var camera = owner.owner.get_node("Fang/Camera2D")

func enter():
	set_physics_process(true)
	curErupts = 1
	owner.get_node("ChargeTimer").stop()
	print("ENTER ENRAGE")
func exit():
	set_physics_process(false)
	print("EXIT ENRAGE")

func _physics_process(delta):
	dirToPoint = (bigGuy.owner.get_node("EnragePoint").global_position - bigGuy.position)
	if dirToPoint.length() > 1:
		if dirToPoint.x > 0: bigGuy.find_child("Sprite2D").flip_h = true
		else: bigGuy.find_child("Sprite2D").flip_h = false
		bigGuy.emit_signal("moveTrue")
		bigGuy.velocity = dirToPoint.normalized() * bigGuy.chargeSpeed
	else:
		owner.get_node("AnimationPlayer").play("EnrageStomp")
		bigGuy.emit_signal("moveFalse")
		if timerRunning == false: 
			owner.get_node("EruptionTimer").start()
			owner.owner.emit_signal("spawnEruptions")
			timerRunning = true

func _on_eruption_timer_timeout():
	print(curErupts, " out of ", maxErupts, " eruptions ")
	if curErupts >= maxErupts:
		var healthSpawn = false
		timerRunning = false
		owner.get_node("EruptionTimer").stop()
		get_parent().changeState("Follow")
	else: 
		owner.owner.emit_signal("spawnEruptions")
		owner.get_node("EruptionTimer").start()
		curErupts+=1

func stompSwitch():
	owner.get_node("Sprite2D").flip_h = !owner.get_node("Sprite2D").flip_h
	owner.get_node("AnimationPlayer").play("EnrageStomp")
	camera.shake(0.2, 2)
	owner.get_node("SFX/SlamSFX").play()
