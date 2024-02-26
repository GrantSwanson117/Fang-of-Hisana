extends RigidBody2D

@onready var area = get_node("FireballVisibility")
@export var minProjDamage: int = 30
@export var maxProjDamage: int = 55
@export var Explosion: PackedScene = preload("res://scenes/explosion.tscn")
var damage: int = randi_range(minProjDamage, maxProjDamage)

func _ready():
	$FireballVisibility/Timer.start()

func _on_timer_timeout():
	queue_free()

func _on_area_2d_area_entered(area):
	if !area.get_parent().is_in_group("player"):
		area.owner.takeDamage(damage)
		explode()

func _on_body_entered(body):
	print("balls")
	if body.is_in_group("world"): explode()

func explode():
	linear_velocity = Vector2.ZERO
	$TrailParticles.emitting = false
	get_node("FireballVisibility/Area2D").queue_free()
	area.hide()
	var explosionInstance = Explosion.instantiate()
	explosionInstance.position = global_position
	explosionInstance.rotation = global_rotation
	explosionInstance.emitting = true
	get_tree().current_scene.add_child(explosionInstance)
