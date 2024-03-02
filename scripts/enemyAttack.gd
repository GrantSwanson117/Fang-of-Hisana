extends State

func enter():
	pass

func _physics_process(delta):
		$Hitbox.look_at(player.global_position)
		if owner.direction.x > 0: $Sprite2D.flip_h = true
		else: $Sprite2D.flip_h = false
