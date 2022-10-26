extends Node

onready var displayModeButton = $MainMenuNavigation/Control/VBoxContainer2/Display/DisplayModeButton
onready var pause = $MainMenuNavigation

var mapMusic = load("res://Assets/Audio/Music/Music1.ogg")

func _ready():
	GlobalMusic._changeMusic(mapMusic)

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("escape"):
			_changeGameState()

func _on_Unpause_pressed():
	if pause.visible:
		GameManager._setGamePaused(false)
		pause.visible = !pause.visible

func _on_MapButton_pressed():
	_on_Unpause_pressed()
	SceneTransition._changeScene("res://Scenes/MainMenu/MainMenu.tscn")

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

func _changeGameState():
	GameManager._setGamePaused(!GameManager._getGamePause())
	pause.visible = !pause.visible
