extends State

func _physics_process(_delta):
	pass

func enter():
	print(bigGuy.name, " entered idle state.")
	bigGuy.emit_signal("moveFalse")

