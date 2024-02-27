extends Node2D

func _ready():
	pass

func dealDamage(amount: int, target: CharacterBody2D):
	if target == null:
		return
	else:
		if target.has_method("takeDamage") and target.get_groups() != get_groups():
			target.takeDamage(amount)
			if target.health <= 0:
				target.health = 0
				if target.has_method("die"): target.die()
