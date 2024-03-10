extends Entity

func ready():
	$CollisionShape2D.disabled = true

func _on_hitbox_area_entered(area):
	var randomDamage = randi_range(minDamage, maxDamage)
	if area.owner.is_in_group("player"):
		dealDamage(randomDamage, area.owner)
