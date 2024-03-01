extends Entity

signal bossDeath
signal moveTrue
signal moveFalse

@onready var player = get_parent().find_child("Fang")
@export var meleeRange : int
@onready var stateMachine = get_node("StateMachine")
@export var chargeSpeed: int
@export var maxCharges: int

var canMove: bool = true
var direction: Vector2

func ready(): 
	health = 3000

func _physics_process(delta):
	#canMove = false
	direction = player.position - global_position
	if stateMachine.currentState != stateMachine.get_node("Charge"):
		$Hitbox.look_at(player.global_position)
		if direction.x > 0: $Sprite2D.flip_h = true
		else: $Sprite2D.flip_h = false
	
	if direction.length() < meleeRange and stateMachine.currentState != get_node("StateMachine/Charge"):
		stateMachine.changeState("Attack")
		$ChargeTimer.stop()
	if direction.length() > meleeRange and stateMachine.currentState != get_node("StateMachine/Charge"):
		stateMachine.changeState("Follow")
		if $ChargeTimer.is_stopped(): $ChargeTimer.start($ChargeTimer.wait_time)
	if canMove: move_and_collide(velocity * delta)
	if stateMachine.currentState == stateMachine.get_node("Follow"): velocity = direction.normalized() * baseSpeed
func canMoveFalse(): 
	canMove = false

func canMoveTrue(): 
	canMove = true
	
func startEncounter():
	stateMachine.changeState("Follow")

func die():
	$AnimationPlayer.play("Die")

func _on_hitbox_area_entered(area):
	dealDamage(damage, area.get_parent())

func _on_charge_timer_timeout():
	stateMachine.changeState("Charge")
