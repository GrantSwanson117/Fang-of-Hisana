extends Entity

signal MoveTrue
signal MoveFalse
@onready var player = get_parent().get_node("Fang")
@onready var stateMachine = $StateMachine
@export var meleeRange : int
var direction : Vector2
var attackSwitch = false
var canMove = true
var spawn = true
var elapsed_time = 0

func _ready():
	health = 150
	$AnimationPlayer.play("Spawn")
	$Hurtbox/CollisionShape2D.disabled = false

func _physics_process(delta):
	direction = global_position - player.global_position
	move_and_collide(velocity * delta)
	#Dissolve in
	if spawn:
		var t : float = elapsed_time / 3
		t = clamp(t, 0.0, 1.0)
		elapsed_time += delta
		var lerpValue = lerp(0.0, 1.1, t)
		$Sprite2D.material.set_shader_parameter('dissolveFloat', lerpValue)
		$Shadow.self_modulate = Color(1, 1, 1, lerp(0.0, 0.3, elapsed_time/3))
		if lerpValue == 1.1: 
			$Sprite2D.material.shader = null
			stateMachine.changeState("Follow")
			spawn = false

func die():
	print("dead")
	#$AnimationTree.active = false
	stateMachine.removeStateMachine()
	$AnimationPlayer.play("Die")

func canMoveFalse(): 
	canMove = false

func canMoveTrue(): 
	canMove = true
