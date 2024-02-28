extends Entity

signal bossDeath
signal moveTrue
signal moveFalse

@onready var player = get_parent().find_child("Fang")
@export var meleeRange : int
@onready var stateMachine = get_node("StateMachine")

var canMove: bool = true
var direction: Vector2

func ready(): health = 3000

func _physics_process(delta):
	direction = player.position - global_position
	
	$Hitbox.look_at(player.global_position)
	
	if direction.x > 0: $Sprite2D.flip_h = true
	else: $Sprite2D.flip_h = false
	
	if direction.length() < meleeRange:
		stateMachine.changeState("Attack")
	if direction.length() > meleeRange:
		stateMachine.changeState("Follow")
	velocity = direction.normalized() * baseSpeed
	if canMove: move_and_collide(velocity * delta)

func canMoveFalse(): 
	canMove = false

func canMoveTrue(): 
	canMove = true
	
func startEncounter():
	pass#stateMachine.changeState("Follow")

func die():
	$AnimationPlayer.play("Die")

func _on_hitbox_area_entered(area):
	dealDamage(damage, area.get_parent())


