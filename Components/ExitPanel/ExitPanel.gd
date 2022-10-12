extends Control

onready var buttonGroup := $NinePatchRect/VBoxContainer/ButtonGroup

func _ready():
	_connectSignals()

func _connectSignals():
	for button in buttonGroup.get_children():
		button.connect("buttonPressed", self, "_buttonClicked")

func _buttonClicked(button):
	match button:
		"Yes":
			get_tree().quit()
		"No":
			self.visible = false
