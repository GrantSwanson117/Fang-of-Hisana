extends Area2D

var healthAmount: int = 20
var time = 0

func _ready(): $AnimatedSprite2D.self_modulate.a = 0

func _physics_process(delta):
	if time < 2:
		time += delta
		$AnimatedSprite2D.self_modulate.a = lerp(0, 1, time / 2)
	else: $AnimatedSprite2D.self_modulate.a = 1

func _on_area_entered(area):
	var randHealth = randi_range(healthAmount - 7, healthAmount + 7)
	if area.owner.is_in_group("player"):
		area.owner.heal(randHealth)
		queue_free()
