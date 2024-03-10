extends CharacterBody2D

@onready var dialoguePoint = $DialoguePoint
@onready var label = $Label
var inRange: bool = false

const lines: Array[String] = [
	"Wait a moment, warrior.",
	"I understand what waits inside is what cursed your people so many moons ago.",
	"But I have seen too many souls venture inside, only to die and awake as undead in its service.",
	"If you value your life, turn back.",
	"But if you were to lay the spirit to rest, I understand you would do your people a great honor.",
	"So if you must press on, I bid you good fortune. I would like not see the spirit's guardians grow any more numerous.",
	"Attack: LMB\nFireball: RMB\nDodge: SPACE"
]
func _ready():
	label.hide()

func _physics_process(_delta):
	if Input.is_action_pressed("dodge") and owner.get_node("Fang").velocity == Vector2.ZERO and inRange:
		DialogueManager.startDialogue($DialoguePosition.global_position, lines)
		label.text = ""

func _on_area_2d_area_entered(area):
	if area.owner != null and area.owner.is_in_group("player"): 
		label.show()
		inRange = true

func _on_area_2d_area_exited(area):
	if area.owner != null and area.owner.is_in_group("player"): 
		inRange = false
		label.hide()
