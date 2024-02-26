extends State

func _ready():
	pass

func enter():
	boss.emit_signal("moveFalse")
	print(boss.name, " entered attack state.")

