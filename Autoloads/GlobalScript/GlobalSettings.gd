extends Node

onready var saveFile = SaveSettings.settingsData

var musicEnabled: bool
var soundEffectEnabled: bool

var musicVolume: float
var soundEffectVolume: float

var displayMode: bool = false

const BGMUSICBUS = "BGMusic"
const SFXBUS = "SFX"

func _setWindowDisplay(value):
	saveFile.fullScreen = value
	SaveSettings._saveSettings()
	
	OS.window_fullscreen = value

func _setMusicVolume(value):
	saveFile.musicVolume = value
	musicVolume = value
	SaveSettings._saveSettings()
	
	var bus = AudioServer.get_bus_index(BGMUSICBUS)
	if value == 0:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, linear2db(value))


func _setSFXVolume(value):
	saveFile.sfxVolume = value
	soundEffectVolume = value
	SaveSettings._saveSettings()
	
	var bus = AudioServer.get_bus_index(SFXBUS)
	if value == 0:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, linear2db(value))

