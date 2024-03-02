extends Node2D

signal partTwo
signal partThree

@onready var leftSpawners : Node2D = get_node("LeftSpawners")
@onready var rightSpawners : Node2D = get_node("RightSpawners")
@onready var Enemy = preload("res://scenes/enemy.tscn")
var totalEnemies: int = 0

func _ready():
	randomize()
	spawn()

func spawn():
	var enemyInstance = Enemy.instantiate()
	var enemyInstance2 = Enemy.instantiate()
	var randomRight = randi_range(0,rightSpawners.get_child_count()-1)
	var randomLeft = randi_range(0,leftSpawners.get_child_count()-1)
	get_tree().current_scene.add_child(enemyInstance)
	enemyInstance.global_position = rightSpawners.get_child(randomRight).global_position
	get_tree().current_scene.add_child(enemyInstance2)
	enemyInstance2.global_position = leftSpawners.get_child(randomLeft).global_position

func _on_spawn_timer_timeout():
	spawn()

func secondPart():
	print("part 2\nasddsaadsadsasddas\nfasdsfsfd\nfafsfsdfds")

func thirdPart():
	print("part 3")
