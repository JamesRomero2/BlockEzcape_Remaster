extends Button

signal buttonPressed(buttonName)

func _on_Button_mouse_entered():
	$OnHoverSounds.play()

func _on_Button_pressed():
	$OnClickSounds.play()
	emit_signal("buttonPressed", self.name)
