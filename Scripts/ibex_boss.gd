extends CharacterBody2D

@onready var player = get_parent().find_child("Fang")

func _ready():
	pass
	
func _physics_process(delta):
	var direction = player.position - position
	if direction.x > 0: $Sprite.flip_h = true
	else: $Sprite.flip_h = false
	
