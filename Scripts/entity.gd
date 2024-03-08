extends CharacterBody2D
class_name Entity

var damage: int
var stateMachineActive: bool
@export var minDamage: int
@export var maxDamage: int
@onready var numberOrigin = get_node("DamageNumbersPosition")

var health: int
@export var maxHealth : int
@export var baseSpeed: int
var originalColor = modulate

func _ready(): health = maxHealth

func takeDamage(amount: int):
	get_node("SFX/HitSFX").play()
	health -= amount
	get_node("Sprite2D").modulate = Color(2,2,2)
	await(get_tree().create_timer(0.1)).timeout
	get_node("Sprite2D").modulate = originalColor
	

func dealDamage(amount: int, target: CharacterBody2D):
	if target == null:
		return
	else:
		if target.has_method("takeDamage") and target.get_groups() != get_groups():
			if amount > maxDamage - 5:
				DamageNumbers.displayNumber(amount, target.numberOrigin.global_position, true, false)
			else: DamageNumbers.displayNumber(amount, target.numberOrigin.global_position, false, false)
			target.takeDamage(amount)
			if target.health <= 0:
				target.health = 0
				if target.has_method("die"): target.die()

func heal(amount: int):
	health += amount
	DamageNumbers.displayNumber(amount, numberOrigin.global_position, false, true)
	get_node("SFX/PickupSFX").play()

