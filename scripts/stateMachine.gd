extends Node

var prevState: State
var currentState: State
@onready var label = owner.get_node("debug")

func _ready():
	for child in get_children():
		child.set_physics_process(false)
	changeState("Idle")

func _physics_process(_delta):
	if Input.is_action_just_pressed("debug"):
		changeState("Follow")
	if Input.is_action_just_pressed("debug2"):
		changeState("Attack")
func changeState(newState):
	if currentState != get_node(newState): 
		prevState = currentState
		currentState = get_node(newState)
		currentState.enter()
		if prevState != null: prevState.exit()
		label.text = currentState.name
