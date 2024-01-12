extends Node2D
 
var currentState: State
var prevState: State
 
func _ready():
	currentState = get_child(0) as State
	prevState = currentState
	currentState.enter()
 
func changeState(state):
	currentState = find_child(state) as State
	currentState.enter()
 
	prevState.exit()
	prevState = currentState
