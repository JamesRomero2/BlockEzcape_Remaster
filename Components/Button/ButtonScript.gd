extends Button

signal buttonPressed(buttonName)

func _on_Button_mouse_entered():
	$OnHoverSounds.play()
	grab_focus()

func _on_Button_pressed():
	$OnClickSounds.play()
	emit_signal("buttonPressed", self.name)

func _on_Button_focus_entered():
	$OnHoverSounds.play()
