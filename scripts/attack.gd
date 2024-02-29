extends State

func _ready():
	pass

func enter():
	if bigGuy.name == "Kufuu, Unbound Ibex": bigGuy.emit_signal("moveFalse")
	#print(boss.name, " entered attack state.")

