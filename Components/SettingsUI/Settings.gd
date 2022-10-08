extends Control

onready var backButton = $Control/VBoxContainer/Control/Back

func _on_DisplayModeButton_pressed():
	GlobalSettings.displayMode = !GlobalSettings.displayMode
	if GlobalSettings.displayMode:
		OS.window_fullscreen = true
		$Control/VBoxContainer/Display/HBoxContainer/Control/DisplayModeButton.text = "FULLSCREEN"
	elif !GlobalSettings.displayMode:
		OS.window_fullscreen = false
		$Control/VBoxContainer/Display/HBoxContainer/Control/DisplayModeButton.text = "WINDOWED"

func _on_MusicVolume_value_changed(value):
	GlobalSettings._setMusicVolume(value)

func _on_SFXVolume_value_changed(value):
	GlobalSettings._setSFXVolume(value)
