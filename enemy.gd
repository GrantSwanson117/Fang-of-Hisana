extends CharacterBody2D

var speed = 100
var motion = Vector2.ZERO
var randomnum
var target
@onready var attack_timer = $AttackTimer

@onready var player : CharacterBody2D = $"../Fang"

enum {
	SURROUND,
	ATTACK,
	HIT,
}

var state = SURROUND

func _ready():
	randomize()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()

func _physics_process(delta):
	match state:
		SURROUND:
			move(get_circle_position(randomnum), delta)
			$White.hide()
		ATTACK:
			move(player.global_position, delta)
		HIT:
			move(player.global_position, delta)
			$White.show()
			#Play attack animation

func move(target, delta):
	var direction = (target - global_position).normalized()
	var desired_velocity = direction * speed
	var steering = (desired_velocity - motion) * delta * 2.5
	motion += steering
	
	set_velocity(motion)
	move_and_slide()
	motion = velocity

func get_circle_position(random):
	var kill_circle_center = player.global_position
	var radius = 60
	var angle = random * PI * 2
	var x = kill_circle_center.x + cos(angle) * radius
	var y = kill_circle_center.y + sin(angle) * radius
	
	return Vector2(x,y)

func _on_AttackTimer_timeout():
	state = ATTACK
