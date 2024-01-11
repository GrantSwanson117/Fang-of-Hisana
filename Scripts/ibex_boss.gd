extends Entity

signal bossDeath
@onready var trigger = owner.find_child("IbexTrigger")

@onready var player = get_parent().find_child("Fang")

func _ready():
	$UI/ProgressBar.max_value = health
	set_physics_process(false)

func _physics_process(delta):
	var direction = player.position - position
	if direction.x > 0: transform.x.x = -0.9
	else: transform.x.x = 0.9
	if position.distance_to(player.position) < 70:
		$AnimationPlayer.play("Attack")
	else: 
		$AnimationPlayer.play("Idle")
		$Hitbox/CollisionShape2D.disabled = true
	move_and_collide(velocity * delta)

func die():
	queue_free()


func _on_hitbox_area_entered(area):
	dealDamage(damage, area.get_parent())

