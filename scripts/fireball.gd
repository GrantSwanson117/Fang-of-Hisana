extends RigidBody2D

@onready var fireballVisible = get_node("FireballVisibility")
@export var minProjDamage: int = 30
@export var maxProjDamage: int = 55
@export var Explosion: PackedScene = preload("res://scenes/explosion.tscn")
@onready var player = get_parent().get_node("Fang")
var damage: int = randi_range(minProjDamage, maxProjDamage)

func _ready():
	$FireballVisibility/Timer.start()

func _on_timer_timeout(): queue_free()

func _on_area_2d_area_entered(area):
	if !area.get_parent().is_in_group("player") and !area.get_parent().is_in_group("friendly"):
		explode()
		if area.owner is CharacterBody2D:
			player.dealDamage(damage, area.owner)

func explode():
	$TrailParticles.emitting = false
	get_node("FireballVisibility/Area2D").queue_free()
	fireballVisible.hide()
	var explosionInstance = Explosion.instantiate()
	explosionInstance.position = global_position
	explosionInstance.rotation = global_rotation
	explosionInstance.emitting = true
	get_tree().current_scene.add_child(explosionInstance)
	linear_velocity = Vector2.ZERO


func _on_area_2d_body_entered(body):
	if body.is_in_group("world"): explode()
