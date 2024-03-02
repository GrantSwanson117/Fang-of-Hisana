extends Node

class_name State

@onready var bigGuy = get_parent().get_parent()
@onready var player = bigGuy.get_parent().find_child("Fang")
@onready var animator = owner.get_node("AnimationPlayer")

func _ready():
	if bigGuy.name == "Kufuu, Unbound Ibex":
		bigGuy.connect("moveFalse", bigGuy.canMoveFalse)
		bigGuy.connect("moveTrue", bigGuy.canMoveTrue)

func enter():
	#print(name, " state entered.")
	set_physics_process(true)

func exit():
	#print(name, " state exited.")
	set_physics_process(false)
	
