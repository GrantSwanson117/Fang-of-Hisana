extends Area2D

@export var target: Entity
@export var idle: bool
@onready var stateMachine = target.find_child("FiniteStateMachine")

func _physics_process(delta):
	if target == null:
		idle = false
		$AnimationPlayer.play("Fade Out")
		$Barrier.collision_mask = 6
	if idle == true:
		$AnimationPlayer.play("Idle")

func _on_body_exited(body):
	if target != null:
		set_deferred("monitoring", false)
		$AnimationPlayer.play("Fade in")
		stateMachine.changeState("Follow")
		$Barrier.collision_mask = 2
		$Barrier.collision_layer = 1
