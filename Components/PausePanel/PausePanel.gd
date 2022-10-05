extends CanvasLayer

func _on_Unpause_pressed():
	get_tree().paused = false
	self.visible = !self.visible


func _on_MainMenu_pressed():
	get_tree().paused = false
	self.visible = !self.visible
#	GO BACK TO MAP SCENE
