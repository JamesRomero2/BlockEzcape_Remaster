extends Control

onready var saveFile = SaveSettings.settingsData

func _ready():
	GlobalSettings.displayMode = saveFile.fullScreen
	GlobalSettings.musicVolume = saveFile.musicVolume
	GlobalSettings.soundEffectVolume = saveFile.sfxVolume
	
	GlobalSettings._setWindowDisplay(GlobalSettings.displayMode)
	GlobalSettings._setMusicVolume(GlobalSettings.musicVolume)
	GlobalSettings._setSFXVolume(GlobalSettings.soundEffectVolume)

func _openMainMenu():
	SceneTransition._changeScene("res://Scenes/MainMenu/MainMenu.tscn")
