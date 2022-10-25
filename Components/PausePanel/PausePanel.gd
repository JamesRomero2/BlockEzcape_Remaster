extends CanvasLayer

onready var displayModeButton = $Control/VBoxContainer2/Display/DisplayModeButton

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

func _on_DisplayModeButton_pressed():
	GlobalSettings.displayMode = !GlobalSettings.displayMode
	if GlobalSettings.displayMode:
		OS.window_fullscreen = true
		displayModeButton.text = "FULLSCREEN"
	elif !GlobalSettings.displayMode:
		OS.window_fullscreen = false
		displayModeButton.text = "WINDOWED"

func _on_MusicVolume_value_changed(value):
	GlobalSettings._setMusicVolume(value)

func _on_SFXVolume_value_changed(value):
	GlobalSettings._setSFXVolume(value)
