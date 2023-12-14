extends CharacterBody2D

var speed = 150
var motion = Vector2.ZERO

func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	motion = input_vector * speed
	
	set_velocity(motion)
	move_and_slide()
	motion = velocity

func _on_Attack_body_entered(body):
	if body.is_in_group("enemies"):
		body.state = body.HIT

func _on_Attack_body_exited(body):
	if body.is_in_group("enemies"):
		body.state = body.SURROUND

func _on_Attract_body_entered(body):
	if body.is_in_group("enemies"):
		body.attack_timer.start()

func _on_Attract_body_exited(body):
	if body.is_in_group("enemies"):
		body.attack_timer.stop()
		body.state = body.SURROUND
