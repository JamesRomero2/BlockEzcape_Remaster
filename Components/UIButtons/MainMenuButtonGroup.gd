extends Control

signal buttonPressedName(buttonName)

func _ready():
	for button in $Buttons.get_children():
		button.connect("mouse_entered", self, "_playOnHoverSFX")
		button.connect("pressed", self, "_playOnClickSFX", [button])

func _playOnHoverSFX():
	$OnHoverSounds.play()

func _playOnClickSFX(button):
	emit_signal("buttonPressedName", button.name)
	$OnClickSounds.play()
