extends CanvasLayer

signal levelOutro
signal playerDeath

const creditsLines: Array[String] = []

@onready var mainMenu = $MainMenu
@onready var optionsMenu = $OptionsMenu
@onready var deathMenu = $DeathMenu
@onready var outroMenu = $OutroMenu
@onready var pauseMenu = $PauseMenu

@onready var outroLabel = $OutroMenu/MarginContainer/VBoxContainer/OutroLabel
@onready var creditsLabel = $OutroMenu/MarginContainer/VBoxContainer/CreditsLabel
@onready var thanksLabel = $OutroMenu/MarginContainer/VBoxContainer/ThanksLabel

var canPause: bool = false
var prevMenu: Control = null
var curMenu: Control = null
var menuFade: bool = false

var outroFade: bool = false
var creditsFade: bool = false
var thanksFade: bool = false

func _ready():
	curMenu = mainMenu
	changeMenu(mainMenu)
	get_tree().paused = false
	connect("playerDeath", onPlayerDeath)
	connect("levelOutro", onLevelOutro)
	outroLabel.modulate.a = 0
	creditsLabel.modulate.a = 0
	thanksLabel.modulate.a = 0

func _physics_process(delta):
	if Input.is_action_pressed("pause") and canPause: 
		get_tree().paused = true
		changeMenu(pauseMenu)
	if menuFade:
		outroMenu.modulate.a += 0.9 * delta
		if outroMenu.modulate.a >= 1: 
			outroFade = true
			menuFade = false
	if outroFade:
		outroLabel.modulate.a += 0.9 * delta
		if outroLabel.modulate.a >= 1:
			creditsFade = true
			outroFade = false
	if creditsFade:
		creditsLabel.modulate.a += 0.9 * delta
		if creditsLabel.modulate.a >= 1:
			thanksFade = true
			creditsFade = false
	if thanksFade:
		thanksLabel.modulate.a += 0.9 * delta
		if thanksLabel.modulate.a >= 1:
			thanksFade = false
			get_tree().paused = true

func changeMenu(newMenu: Control):
	if newMenu == prevMenu:
		curMenu = newMenu
	else:
		prevMenu = curMenu
		curMenu = newMenu
		print("Switching to menu: ", curMenu.name, "from: ", prevMenu.name)
	for menu in get_children(): 
		menu.hide()
	newMenu.show()

func exitMenu():
	for menu in get_children(): 
		menu.hide()

func _on_quit_pressed(): get_tree().quit()

func _on_play_pressed():
	canPause = true
	exitMenu()
	owner.get_node("Fang/UI").show()
	owner.get_node("Fang").set_physics_process(true)

func onLevelOutro():
	outroMenu.modulate = Color(1, 1, 1, 0)
	changeMenu(outroMenu)
	menuFade = true

func _on_resume_pressed():
	exitMenu()
	get_tree().paused = false

func _on_options_pressed():
	changeMenu(optionsMenu)

func _on_back_pressed():
	if prevMenu:
		changeMenu(prevMenu)
	else: print("Error: prevMenu is not set.")

func _on_restart_pressed():
	get_tree().reload_current_scene()

func onPlayerDeath():
	changeMenu(deathMenu)
