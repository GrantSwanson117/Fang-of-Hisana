extends State

func _ready():
	pass

func enter():
	owner.get_node("Hitbox/CollisionPolygon2D").disabled = true
	if bigGuy.name == "Kufuu, Unbound Ibex": bigGuy.emit_signal("moveFalse")
	#print(boss.name, " entered attack state.")

