extends Control

signal buttonPressedName(buttonName)

func _ready():
	for button in $Buttons.get_children():
		button.connect("buttonPressed", self, "_buttonClicked")

func _buttonClicked(button):
	emit_signal("buttonPressedName", button)