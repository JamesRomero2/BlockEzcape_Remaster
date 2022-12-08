extends CanvasLayer

onready var displayModeButton = $Control/VBoxContainer2/Display/DisplayModeButton

func _ready():
	_windowsButtonToggle()
	$Control/VBoxContainer2/Music/MusicVolume.value = GlobalSettings._getMusicVolume()
	$Control/VBoxContainer2/SoundEffects/SFXVolume.value = GlobalSettings._getSFXVolume()

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("escape"):
			_unpause()

func _on_Unpause_pressed():
	_unpause()

func _unpause():
	GameManager._setGamePaused(false)
	GameManager._setGameTimerActive(true)
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	get_parent().set_process_unhandled_input(true)

func _on_MainMenuButton_pressed():
	_unpause()
	LoadingScreen.loadLevel("MainMenu")

func _on_MapButton_pressed():
	_unpause()
	LoadingScreen.loadLevel("WorldMap")

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

func _on_Restart_pressed():
	_unpause()
	var _reload = get_tree().reload_current_scene()
