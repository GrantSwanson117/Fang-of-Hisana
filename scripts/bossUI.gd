extends CanvasLayer

@onready var progessBar = $ProgressBar
@onready var label = $ProgressBar/Label

func _ready():
	progessBar.max_value = get_parent().maxHealth

func _physics_process(_delta):
	progessBar.value = get_parent().health
