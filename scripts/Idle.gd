extends State

@onready var collision = $"../../PlayerDetection/CollisionShape2D"
@onready var healthBar = owner.find_child("ProgressBar")

var playerEntered: bool = false:
	set(value):
		playerEntered = value
		collision.set_deferred("disabled", value)
		healthBar.set_deferred("visible", value)

func _ready():
	pass

func _process(delta):
	pass
