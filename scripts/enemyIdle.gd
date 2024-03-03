extends State

func _physics_process(_delta):
	owner.get_node("AnimationPlayer").play("Spawn")
