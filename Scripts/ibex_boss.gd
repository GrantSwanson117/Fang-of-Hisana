extends Entity

signal moveTrue
signal moveFalse

@onready var player = get_parent().find_child("Fang")
@export var meleeRange : int
@onready var stateMachine = get_node("StateMachine")
@export var chargeSpeed: int
@export var maxCharges: int = 3
@export var chargeBonus: int = 20
var dead : bool = false
var elapsed_time = 0.0
var partTwoEmitted = false
var partThreeEmitted = false

var canMove: bool = true
var direction: Vector2

func ready(): 
	health = maxHealth

func _physics_process(delta):
	#canMove = false
	direction = player.position - global_position
	if stateMachine.currentState != stateMachine.get_node("Charge"):
		$Hitbox.look_at(player.global_position)
		if direction.x > 0: $Sprite2D.flip_h = true
		else: $Sprite2D.flip_h = false
	
	if direction.length() < meleeRange and stateMachine.currentState == get_node("StateMachine/Follow"):
		stateMachine.changeState("Attack")
		$ChargeTimer.stop()
	if direction.length() > meleeRange + 20 and stateMachine.currentState == get_node("StateMachine/Attack"):
		stateMachine.changeState("Follow")
		if $ChargeTimer.is_stopped(): $ChargeTimer.start($ChargeTimer.wait_time)
	if canMove: move_and_collide(velocity * delta)
	if stateMachine.currentState == stateMachine.get_node("Follow"): velocity = direction.normalized() * baseSpeed
	
	if health < 2 * (maxHealth / 3) and !partTwoEmitted: 
		owner.emit_signal("partTwo")
		partTwoEmitted = true
	if health < (maxHealth / 3) and !partThreeEmitted: 
		owner.emit_signal("partThree")
		partThreeEmitted = true

func _process(delta):
	#Dissolve out
	if dead:
		owner.emit_signal("endEncounter")
		stateMachineActive = false
		$Sprite2D.material.shader = load("res://resources/dissolve.tres")
		var t = elapsed_time / 3
		t = clamp(t, 0.0, 1.0)
		elapsed_time += delta
		var lerpValue = lerp(1.1, 0.0, t)
		$Sprite2D.material.set_shader_parameter('dissolveFloat', lerpValue)
		$Shadow.self_modulate = Color(1, 1, 1, lerp(1.0, 0.0, elapsed_time/3))
		$UI/ProgressBar.modulate = Color(1, 1, 1, lerp(1.0, 0.0, elapsed_time/3))
		if lerpValue == 0: queue_free()
	
func canMoveFalse(): 
	canMove = false

func canMoveTrue(): 
	canMove = true
	
func startFight():
	stateMachineActive = true
	stateMachine.changeState("Follow")
	$UI.visible = true

func die():
	dead = true
	stateMachine.currentState.exit()
	$AnimationPlayer.play("Die")
	set_physics_process(false)

func _on_hitbox_area_entered(area):
	dealDamage(damage, area.get_parent())

func _on_charge_timer_timeout():
	stateMachine.changeState("Charge")
