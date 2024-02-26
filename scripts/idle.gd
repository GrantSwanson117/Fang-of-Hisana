extends State

func _physics_process(_delta):
	pass

func enter():
	print(boss.name, " entered idle state.")
	boss.emit_signal("moveFalse")

