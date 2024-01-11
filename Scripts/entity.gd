extends CharacterBody2D
class_name Entity

var damage: int
@export var health: int
@export var minDamage: int
@export var maxDamage: int
@export var baseSpeed: int


func takeDamage(amount: int):
	health -= amount
	#print(health)

func dealDamage(amount: int, target: CharacterBody2D):
	if target == null:
		return
	else:
		if target.has_method("takeDamage") and target.get_groups() != get_groups():
			target.takeDamage(damage)
			if target.health <= 0:
				target.health = 0
				if target.has_method("die"): target.die()
