extends Node2D

signal partTwo
signal partThree
signal endEncounter
signal startEncounter
signal spawnEruptions

@onready var leftSpawners : Node2D = get_node("LeftSpawners")
@onready var rightSpawners : Node2D = get_node("RightSpawners")
@onready var Enemy = preload("res://scenes/enemy.tscn")
@onready var HealthItem = preload("res://scenes/healthItem.tscn")
@onready var Pyre = preload("res://scenes/pyre.tscn")
@export var healthTime : int
var sfxSwitch = false
@onready var rect = $HealthField/CollisionShape2D
var rectangleShape = RectangleShape2D.new()
var size : Vector2
var totalEnemies: int = 0
var maxEnemyCount: int

func _ready():
	$SFX/DrumsSFX.play()
	randomize()
	$SpawnTimer.wait_time = 1
	var existing_shape = rect.shape
	if rectangleShape and existing_shape is RectangleShape2D:
		rectangleShape.extents = existing_shape.extents
	connect("partTwo", secondPart)
	connect("partThree", thirdPart)
	connect("startEncounter", onStartEncounter)
	connect("endEncounter", onEndEncounter)
	connect("spawnEruptions", spawnPyres)

func spawn():
	$SFX/EnemySpawnSFX.play()
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
		if child.is_in_group(objectName):
			count+=1
	return count

func _on_spawn_timer_timeout():
	if countEntities("enemy") < maxEnemyCount:
		spawn()

func spawnHealth():
	var random_position = Vector2(
		randf_range(-rectangleShape.extents.x, rectangleShape.extents.x),
		randf_range(-rectangleShape.extents.y, rectangleShape.extents.y))
	var healthItemInstance = HealthItem.instantiate()
	add_child(healthItemInstance)
	healthItemInstance.global_position = random_position

func spawnPyres():
	sfxSwitch = !sfxSwitch
	if sfxSwitch: $SFX/PyreSFX2.play()
	elif !sfxSwitch: $SFX/PyreSFX.play()
	
	var min_distance = 30
	var positions = []
	
	for i in range(80):
		var random_position = Vector2()
		var positionValid = false
		while !positionValid:
			random_position = Vector2(
				randf_range(-rectangleShape.extents.x, rectangleShape.extents.x + 80),
				randf_range(-rectangleShape.extents.y, rectangleShape.extents.y))
			positionValid = true
			for existing_position in positions:
				if random_position.distance_to(existing_position) < min_distance:
					positionValid = false
		if positionValid:
			var pyreInstance = Pyre.instantiate()
			add_child(pyreInstance)
			pyreInstance.global_position = random_position
			positions.append(random_position)

func secondPart():
	get_node("Kufuu, Unbound Ibex/StateMachine").changeState("Enrage")
	get_node("Kufuu, Unbound Ibex/StateMachine/Enrage").maxErupts = 4
	spawn()
	print("Part 2 entered")
	$SpawnTimer.wait_time = 12
	maxEnemyCount = 6
	$SpawnTimer.start()
	get_node("Kufuu, Unbound Ibex").chargeSpeed += 40
	get_node("Kufuu, Unbound Ibex").maxCharges += 1
	get_node("Kufuu, Unbound Ibex/ChargeTimer").wait_time = 4

func thirdPart():
	get_node("Kufuu, Unbound Ibex/StateMachine").changeState("Enrage")
	get_node("Kufuu, Unbound Ibex/StateMachine/Enrage").maxErupts = 6
	print("part 3 entered")
	maxEnemyCount = 10
	$SpawnTimer.wait_time -= 3
	get_node("Kufuu, Unbound Ibex").maxCharges += 1
	get_node("Kufuu, Unbound Ibex").chargeSpeed += 60

func onStartEncounter():
	$Keeper.hide()
	$SFX/DrumsSFX.stop()
	if get_node("Kufuu, Unbound Ibex").has_method("startFight"):
		get_node("Kufuu, Unbound Ibex").startFight()
	$HealthTimer.wait_time = healthTime
	$HealthTimer.start()
	
func onEndEncounter():
	$HealthTimer.stop()
	$SpawnTimer.stop()
	for child in get_children():
		if child.is_in_group("enemy"):
			if child.get_node("AnimationPlayer").current_animation != "Spawn":
				child.stateMachineActive = false
				child.die()
	for child in get_children():
		if child.is_in_group("enemy"):
			child.stateMachineActive = false
			child.die()

func _on_health_timer_timeout():
	$HealthTimer.wait_time = randf_range(healthTime - 7, healthTime + 7)
	$HealthTimer.start()
	if countEntities("healthItem") < 3:
		spawnHealth()

func _on_drums_sfx_finished():
	$SFX/DrumsSFX.play()


func _on_level_end_area_exited(area):
	if area.owner.is_in_group("player"):
		$UI.emit_signal("levelOutro")
