extends Control

onready var backButton = $Control/VBoxContainer/Control/Back
onready var displayModeButton = $Control/VBoxContainer/HBoxContainer/Control/DisplayModeButton

func _ready():
	_windowsButtonToggle()
	$Control/VBoxContainer/HBoxContainer2/Control/MusicVolume.value = GlobalSettings.musicVolume
	$Control/VBoxContainer/HBoxContainer3/Control/SFXVolume.value = GlobalSettings.soundEffectVolume

func _on_DisplayModeButton_pressed():
	GlobalSettings.displayMode = !GlobalSettings.displayMode
	GlobalSettings._setWindowDisplay(GlobalSettings.displayMode)
	_windowsButtonToggle()

func _windowsButtonToggle():
	if GlobalSettings.displayMode:
		displayModeButton.text = "FULLSCREEN"
	elif !GlobalSettings.displayMode:
		displayModeButton.text = "WINDOWED"

func _on_MusicVolume_value_changed(value):
	GlobalSettings._setMusicVolume(value)

func _on_SFXVolume_value_changed(value):
	GlobalSettings._setSFXVolume(value)
