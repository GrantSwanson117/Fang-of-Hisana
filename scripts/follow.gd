extends State

func _ready():
	pass
func _physics_process(_delta):
	pass

func enter():
	boss.emit_signal("moveTrue")
	print(boss.name, " entered follow state.")
