extends State

func _physics_process(delta):
	owner.get_node("AnimationPlayer").play("Spawn")
