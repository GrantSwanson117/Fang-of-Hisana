extends State


func _ready():
	pass
func _physics_process(_delta):
	owner.velocity = owner.direction.normalized() * owner.baseSpeed

func enter():
	owner.baseSpeed = 80
	bigGuy.emit_signal("moveTrue")
	owner.get_node("ChargeTimer").start()
	#print(boss.name, " entered follow state.")
