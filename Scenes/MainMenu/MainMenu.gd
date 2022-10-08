extends Node

onready var buttonGroup = $MainMenuUI/Buttons/ButtonGroup

func _ready():
	buttonGroup.connect("buttonPressedName", self, "_buttonPressed")

func _buttonPressed(name):
	match name:
		"Continue":
			print("Continue Button Pressed")
		"NewGame":
			print("Continue Button Pressed")
		"HowToPlay":
			print("Continue Button Pressed")
		"Settings":
			$Settings.visible = true
		"Exit":
			get_tree().quit()
	$MainMenuUI.visible = false

func _on_Cancel_pressed():
	$Settings.visible = false
	$MainMenuUI.visible = true
