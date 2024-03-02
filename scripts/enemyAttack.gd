extends State

var attackSwitch : bool = false

func enter():
	set_physics_process(true)
	attack()

func _physics_process(delta):
	owner.canMove = false

func attack():
	if !attackSwitch: owner.get_node("AnimationPlayer").play("Attack1")
	if attackSwitch: owner.get_node("AnimationPlayer").play("Attack2")
	owner.get_node("Hitbox").look_at(player.global_position)
	if owner.get_node("Hitbox").get_node("CollisionShape2D").global_position.x > owner.global_position.x: 
		owner.get_node("Sprite2D").flip_h = false
	else: owner.get_node("Sprite2D").flip_h = true

func attackEnd():
	owner.direction = player.global_position - owner.global_position
	if owner.direction.length() > owner.meleeRange: get_parent().changeState("Follow")
	else:
		await(get_tree().create_timer(owner.attackCooldown)).timeout
		attackSwitch = !attackSwitch
		print(attackSwitch)
		attack()
