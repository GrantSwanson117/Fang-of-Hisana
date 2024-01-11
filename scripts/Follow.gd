extends State

func enter():
	super.enter()
	owner.set_physics_process(true)
	animator.play("Idle")

func exit():
	super.exit()
	owner.set_physics_process(false)
