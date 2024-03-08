extends Node

var prevState: State
var currentState: State
@onready var label = owner.get_node("debug")

func _ready():
	for child in get_children():
		child.set_physics_process(false)
	changeState("Idle")
	owner.stateMachineActive = false

func changeState(newState):
	if currentState != get_node(newState) and owner.stateMachineActive: 
		prevState = currentState
		currentState = get_node(newState)
		currentState.enter()
		if prevState != null: prevState.exit()
		label.text = currentState.name

func removeStateMachine():
	for child in get_children():
		child.exit()
	queue_free()
