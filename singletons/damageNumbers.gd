extends Node

func displayNumber(value: int, position: Vector2, isCritical: bool, isHeal: bool):
	var number = Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color = "#FFF"
	if isCritical:
		color = Color.DARK_SALMON
	if value == 0:
		color = "#FFF8"
	if isHeal: 
		color = Color.PALE_GREEN
	number.label_settings.font_color = color
	number.label_settings.font_size = 24
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	number.label_settings.font = load("res://fonts/alagard.ttf")
	
	call_deferred("add_child",number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.4
	)
	
	await tween.finished
	number.queue_free()
