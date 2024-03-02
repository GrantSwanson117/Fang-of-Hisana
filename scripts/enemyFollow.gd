extends State

func _physics_process(delta):
	owner.canMove = true
	animator.play("Walk")
	owner.direction = player.position - owner.global_position
	owner.velocity = owner.direction.normalized() * owner.baseSpeed
	
	if owner.direction.x > 0: owner.get_node("Sprite2D").flip_h = false
	else: owner.get_node("Sprite2D").flip_h = true
	if owner.direction.length() < owner.meleeRange:
		get_parent().changeState("Attack")
