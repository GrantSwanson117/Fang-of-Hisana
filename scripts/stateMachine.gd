extends Node

var prevState:State
var currentState:State
@onready var label = owner.get_node("debug")

func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		changeState(get_node("Attack"))

func changeState(newState):
	currentState = get_node(newState)
	for state in get_children():
		state.set_process(false)
	currentState.setProcess(true)
	label.text = currentState.name
	print("State changed.")
