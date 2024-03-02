extends State

func _physics_process(delta):
	animator.play("Walk")
	owner.direction = player.position - owner.global_position
	owner.velocity = owner.direction.normalized() * owner.baseSpeed
	
