extends State

@onready var camera = owner.owner.get_node("Fang/Camera2D")

func _ready():
	pass

func enter():
	owner.get_node("Hitbox").look_at(owner.owner.get_node("Fang").global_position)
	if owner.direction.x > 0: owner.get_node("Sprite2D").flip_h = true
	else: owner.get_node("Sprite2D").flip_h = false
	owner.get_node("AnimationPlayer").play("Attack")
	owner.get_node("Hitbox/CollisionPolygon2D").disabled = true
	if bigGuy.name == "Kufuu, Unbound Ibex": bigGuy.emit_signal("moveFalse")
	#print(boss.name, " entered attack state.")

func onAttackEnd():
	owner.get_node("AttackTimer").start()

func _on_attack_timer_timeout():
	if owner.direction.length() < owner.meleeRange:
		enter()
	elif get_parent().currentState == get_parent().get_node("Attack"): 
		get_parent().changeState("Follow")

func attackFX():
	camera.shake(0.2, 2)
	owner.get_node("SFX/SlamSFX").play()
