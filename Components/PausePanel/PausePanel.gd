extends CanvasLayer

func _on_Unpause_pressed():
	if self.visible:
		GameManager._setGamePaused(false)
		self.visible = !self.visible

func _on_MainMenuButton_pressed():
	_on_Unpause_pressed()
	SceneTransition._changeScene("res://Scenes/MainMenu/MainMenu.tscn")

func _on_MapButton_pressed():
	_on_Unpause_pressed()
	SceneTransition._changeScene("res://Scenes/WorldMap/WorldMap.tscn")
