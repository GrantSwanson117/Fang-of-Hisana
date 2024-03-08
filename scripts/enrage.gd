extends State

var pyresInProgress: bool = false
var elapsed_time: int = 0
var dirToPoint: Vector2
var directionFacing: int = 1
@export var maxErupts = 4
var curErupts: int = 0
var timerRunning: bool = false

func enter():
	set_physics_process(true)
	curErupts = 0

func _physics_process(delta):
	dirToPoint = (bigGuy.owner.get_node("EnragePoint").global_position - bigGuy.position)
	if dirToPoint.length() > 1:
		bigGuy.emit_signal("moveTrue")
		bigGuy.velocity = dirToPoint.normalized() * bigGuy.chargeSpeed
	else:
		bigGuy.emit_signal("moveFalse")
		if timerRunning == false: 
			owner.get_node("EruptionTimer").start()
			owner.owner.emit_signal("spawnEruptions")
			timerRunning = true

func _on_eruption_timer_timeout():
	curErupts+=1
	if curErupts >= maxErupts:
		var healthSpawn = false
		get_parent().changeState("Follow")
	else: 
		owner.owner.emit_signal("spawnEruptions")
		owner.get_node("EruptionTimer").start()
