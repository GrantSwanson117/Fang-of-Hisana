extends Area2D

@export var target: Entity
@export var idle: bool
@export var triggerGate: bool
@onready var stateMachine = target.find_child("FiniteStateMachine")

func _ready():
	idle = false
	$AnimationPlayer.play("Inactive")

func _physics_process(_delta):
	if target == null:
		idle = false
		$AnimationPlayer.play("Fade Out")
		$Barrier.collision_mask = 6
	if idle == true:
		$AnimationPlayer.play("Idle")
	if triggerGate == false:
		set_deferred("monitoring", false)
		idle = true
		$Barrier.collision_mask = 2
		$Barrier.collision_layer = 1

func _on_body_exited(_body):
	if target != null and triggerGate:
		set_deferred("monitoring", false)
		$AnimationPlayer.play("Fade in")
		$Barrier.collision_mask = 2
		$Barrier.collision_layer = 1
		owner.emit_signal("startEncounter")
