extends Node

onready var saveFile = SaveSettings.settingsData

var musicVolume: float setget _setMusicVolume, _getMusicVolume
var sfxVolume: float setget _setSFXVolume, _getSFXVolume

var windowDisplay: bool = false setget _setWindowDisplay, _getWindowDisplay

const BGMUSICBUS = "BGMusic"
const SFXBUS = "SFX"

func _ready():
	_setWindowDisplay(_getWindowDisplay())
	_setMusicVolume(_getMusicVolume())
	_setSFXVolume(_getSFXVolume())

func _setWindowDisplay(value):
	saveFile.fullScreen = value
	windowDisplay = value
	SaveSettings._saveSettings()
	
	OS.window_fullscreen = value

func _getWindowDisplay():
	windowDisplay = saveFile.fullScreen
	return windowDisplay

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

func _getMusicVolume():
	musicVolume = saveFile.musicVolume
	return musicVolume

func _setSFXVolume(value):
	saveFile.sfxVolume = value
	sfxVolume = value
	SaveSettings._saveSettings()
	
	var bus = AudioServer.get_bus_index(SFXBUS)
	if value == 0:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, linear2db(value))

func _getSFXVolume():
	sfxVolume = saveFile.sfxVolume
	return sfxVolume
