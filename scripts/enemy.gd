extends Entity

@onready var player = get_parent().get_node("Fang")
@onready var stateMachine = $StateMachine
@export var meleeRange : int
@export var attackCooldown: int
var direction : Vector2
var canMove = true
var spawn = true
var elapsed_time = 0
var dead: bool = false

func _ready():
	if $Sprite2D.material:
		$Sprite2D.material.set_shader_parameter('dissolveFloat', 0.0)
		$Sprite2D.material = $Sprite2D.material.duplicate()
	health = 150
	$AnimationPlayer.play("Spawn")
	$Hurtbox/CollisionShape2D.disabled = false
	stateMachineActive = true

func _physics_process(delta):
	if canMove:
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
			$Sprite2D.material = null
			stateMachine.changeState("Follow")
			spawn = false

func die():
	if !dead:
		#stateMachine.removeStateMachine()
		$AnimationPlayer.play("Die")
		get_node("SFX/DeathSFX").play()
		velocity = Vector2.ZERO
		#stateMachineActive = false
		dead = true

func _on_hitbox_area_entered(area):
	damage = randi_range(minDamage, maxDamage)
	dealDamage(damage, area.get_parent())
