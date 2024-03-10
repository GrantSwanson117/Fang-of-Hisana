extends Node

@onready var TextBoxScene = preload("res://scenes/textBox.tscn")

var dialogueLines: Array[String] = []
var currentLineIndex = 0

var textBox
var textBoxPosition: Vector2
var dialogueActive: bool = false
var canAdvanceTime: bool = false

func startDialogue(position: Vector2, lines: Array[String]):
	if dialogueActive:
		return
	dialogueLines = lines
	textBoxPosition = position
	if !currentLineIndex >= dialogueLines.size(): showTextBox()
	dialogueActive = true

func showTextBox():
	textBox = TextBoxScene.instantiate()
	textBox.finishedDisplaying.connect(onTextBoxFinishedDisplaying)
	get_tree().current_scene.add_child(textBox)
	textBox.global_position = textBoxPosition
	textBox.displayText(dialogueLines[currentLineIndex])
	canAdvanceTime = false

func onTextBoxFinishedDisplaying():
	canAdvanceTime = true

func _unhandled_input(event):
	if event.is_action_pressed("dodge") and dialogueActive and canAdvanceTime:
		textBox.queue_free()
		currentLineIndex += 1
		if currentLineIndex >= dialogueLines.size():
			dialogueActive = false
			canAdvanceTime = false
			#currentLineIndex = 0
			return 
		showTextBox()
