extends State

func _ready():
	pass
func _physics_process(_delta):
	owner.velocity = owner.direction.normalized() * owner.baseSpeed
	print(owner.get_node("Sprite2D").name)
	owner.get_node("Hitbox").look_at(player.global_position)
	if owner.direction.x > 0: owner.get_node("Sprite2D").flip_h = true
	else: owner.get_node("Sprite2D").flip_h = false

func enter():
	owner.get_node("Hitbox/CollisionPolygon2D").set_deferred("disabled", true)
	owner.baseSpeed = 80
	bigGuy.emit_signal("moveTrue")
	owner.get_node("ChargeTimer").start()
	#print(boss.name, " entered follow state.")
