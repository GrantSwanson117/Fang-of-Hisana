extends Entity

signal bossDeath
@onready var player = get_parent().find_child("Fang")

var direction: Vector2

func _ready():
	$UI/ProgressBar.max_value = health
	set_physics_process(false)

func _process(delta):
	direction = player.position - position
	
	if direction.x > 0: $Sprite.flip_h = true
	else: $Sprite.flip_h = false

func _physics_process(delta):
	velocity = direction.normalized() * baseSpeed
	move_and_collide(velocity * delta)

func die():
	queue_free()

func _on_hitbox_area_entered(area):
	dealDamage(damage, area.get_parent())

