extends Entity

signal MoveTrue
signal MoveFalse
@onready var player = get_parent().get_node("Fang")
var attackSwitch = false
var canMove = true

func _ready():
	health = 150
	$AnimationPlayer.play("Idle")
	
	#print(canMove)
	$Hurtbox/CollisionShape2D.disabled = false

func _physics_process(delta):
	var direction = global_position - player.global_position
	velocity = direction.normalized() * baseSpeed
	if canMove: move_and_collide(velocity * delta)

func die():
	$AnimationTree.active = false
	$AnimationPlayer.play("Die")

func canMoveFalse(): 
	canMove = false

func canMoveTrue(): 
	canMove = true
