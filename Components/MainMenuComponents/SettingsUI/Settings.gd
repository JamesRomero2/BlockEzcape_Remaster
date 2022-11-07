extends Control

onready var backButton = $Control/VBoxContainer/Control/Back
onready var displayModeButton = $Control/VBoxContainer/HBoxContainer/Control/DisplayModeButton

func _ready():
	_windowsButtonToggle()
	$Control/VBoxContainer/HBoxContainer2/Control/MusicVolume.value = GlobalSettings._getMusicVolume()
	$Control/VBoxContainer/HBoxContainer3/Control/SFXVolume.value = GlobalSettings._getSFXVolume()

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
