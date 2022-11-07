extends CanvasLayer

onready var displayModeButton = $Control/VBoxContainer2/Display/DisplayModeButton

func _ready():
	_windowsButtonToggle()
	$Control/VBoxContainer2/Music/MusicVolume.value = GlobalSettings._getMusicVolume()
	$Control/VBoxContainer2/SoundEffects/SFXVolume.value = GlobalSettings._getSFXVolume()

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("escape"):
			_on_Unpause_pressed()

func _on_Unpause_pressed():
	if self.visible:
		GameManager._setGamePaused(false)
		GameManager._setGameTimerActive(!GameManager._getGameTimerActive())
		self.visible = !self.visible
		get_tree().paused = false
		get_parent().set_process_unhandled_input(true)

func _on_MainMenuButton_pressed():
	_on_Unpause_pressed()
	SceneTransition._changeScene("res://Scenes/MainMenu/MainMenu.tscn")

func _on_MapButton_pressed():
	_on_Unpause_pressed()
	SceneTransition._changeScene("res://Scenes/WorldMap/WorldMap.tscn")

func _on_DisplayModeButton_pressed():
	GlobalSettings._setWindowDisplay(!GlobalSettings._getWindowDisplay())
	_windowsButtonToggle()

func _windowsButtonToggle():
	if GlobalSettings._getWindowDisplay():
		displayModeButton.text = "FULLSCREEN"
	elif !GlobalSettings._getWindowDisplay():
		displayModeButton.text = "WINDOWED"

func _on_MusicVolume_value_changed(value):
	GlobalSettings._setMusicVolume(value)

func _on_SFXVolume_value_changed(value):
	GlobalSettings._setSFXVolume(value)
