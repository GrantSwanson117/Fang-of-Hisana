extends Node

class_name State

@onready var bigGuy = get_parent().get_parent()
@onready var player = owner.owner.find_child("Fang")

func _ready():
	if bigGuy.name == "Kufuu, Unbound Ibex":
		bigGuy.connect("moveFalse", bigGuy.canMoveFalse)
		bigGuy.connect("moveTrue", bigGuy.canMoveTrue)
	else: pass

func enter():
	#print(name, " state entered.")
	set_physics_process(true)

func exit():
	#print(name, " state exited.")
	set_physics_process(false)
	
