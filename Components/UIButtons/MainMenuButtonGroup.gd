extends Control

signal buttonPressedName(buttonName)

func _ready():
	if GameManager._getOpenLevels().size() > 1:
		$Continue.visible = true
	else:
		$Continue.visible = false

	for button in get_children():
		button.connect("buttonPressed", self, "_buttonClicked")

func _buttonClicked(button):
	emit_signal("buttonPressedName", button)

