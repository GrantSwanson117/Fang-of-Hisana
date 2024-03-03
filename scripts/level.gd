extends Node2D

signal partTwo
signal partThree

@onready var leftSpawners : Node2D = get_node("LeftSpawners")
@onready var rightSpawners : Node2D = get_node("RightSpawners")
@onready var Enemy = preload("res://scenes/enemy.tscn")
@onready var HealthItem = preload("res://scenes/healthItem.tscn")
@export var healthTime : int
@onready var rect = $HealthField/CollisionShape2D
var rectangleShape = RectangleShape2D.new()
var totalEnemies: int = 0
var size : Vector2
var maxEnemyCount: int

func _ready():
	var existing_shape = rect.shape
	if rectangleShape and existing_shape is RectangleShape2D:
		rectangleShape.extents = existing_shape.extents
	$HealthTimer.wait_time = healthTime
	$HealthTimer.start()
	randomize()
	spawn()
	connect("partTwo", secondPart)
	connect("partThree", thirdPart)

func spawn():
	var enemyInstance = Enemy.instantiate()
	var enemyInstance2 = Enemy.instantiate()
	var randomRight = randi_range(0,rightSpawners.get_child_count()-1)
	var randomLeft = randi_range(0,leftSpawners.get_child_count()-1)
	get_tree().current_scene.add_child(enemyInstance)
	enemyInstance.global_position = rightSpawners.get_child(randomRight).global_position
	get_tree().current_scene.add_child(enemyInstance2)
	enemyInstance2.global_position = leftSpawners.get_child(randomLeft).global_position

func countEntities(objectName: String):
	var count = 0
	for child in get_children():
		if child.is_in_group("healthItem"):
			count+=1
	return count

func _on_spawn_timer_timeout():
	spawn()

func spawnHealth():
	var random_position = Vector2(
		randf_range(-rectangleShape.extents.x, rectangleShape.extents.x),
		randf_range(-rectangleShape.extents.y, rectangleShape.extents.y))
	var healthItemInstance = HealthItem.instantiate()
	add_child(healthItemInstance)
	healthItemInstance.global_position = random_position

func secondPart():
	print("part 2\nasddsaadsadsasddas\nfasdsfsfd\nfafsfsdfds")

func thirdPart():
	print("part 3")

func _on_health_timer_timeout():
	$HealthTimer.wait_time = randf_range(healthTime - 7, healthTime + 7)
	$HealthTimer.start()
	if countEntities("HealthItem") < 3:
		spawnHealth()
	
