extends CanvasLayer

signal levelOutro

@onready var mainMenu = $MainMenu
@onready var pauseOptionsMenu = $PauseOptionsMenu
@onready var startOptionsMenu = $StartOptionsMenu
@onready var deathMenu = $DeathMenu
@onready var outroMenu = $OutroMenu
@onready var pauseMenu = $PauseMenu
var canPause: bool = false

func _ready():
	changeMenu(mainMenu)
	get_tree().paused = false
	#process_mode = Node.PROCESS_MODE_PAUSABLE
	connect("levelOutro", onLevelOutro)

func _physics_process(delta):
	if Input.is_action_pressed("pause") and canPause: 
		get_tree().paused = true
		changeMenu(pauseMenu)
func changeMenu(newMenu: Control):
	for menu in get_children(): 
		menu.hide()
	newMenu.show()

func exitMenu():
	for curMenu in get_children(): 
		curMenu.hide()

func _on_quit_pressed(): get_tree().quit()

func _on_play_pressed():
	canPause = true
	exitMenu()
	owner.get_node("Fang/UI").show()
	owner.get_node("Fang").set_physics_process(true)

func onLevelOutro():
	print("balls")

func _on_options_pressed():
	changeMenu(optionsMenu)

func _on_resume_pressed():
	exitMenu()
	get_tree().paused = false
