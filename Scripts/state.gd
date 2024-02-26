extends Node

class_name State

@onready var boss = get_parent().get_parent()
@onready var player = owner.owner.find_child("Fang")

func _ready():
	pass
	boss.connect("moveFalse", boss.canMoveFalse)
	boss.connect("moveTrue", boss.canMoveTrue)

func enter():
	print(name, " state entered.")
	set_physics_process(true)

func exit():
	#print(name, " state exited.")
	set_physics_process(false)
	
