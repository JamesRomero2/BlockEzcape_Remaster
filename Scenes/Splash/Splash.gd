extends Control

onready var saveFile = SaveSettings.settingsData

func _ready():
	GlobalSettings._setWindowDisplay(GlobalSettings._getWindowDisplay())
	GlobalSettings._setMusicVolume(GlobalSettings._getMusicVolume())
	GlobalSettings._setSFXVolume(GlobalSettings._getSFXVolume())

func _openMainMenu():
	LoadingScreen.loadLevel("MainMenu")
