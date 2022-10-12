extends Node

var musicEnabled: bool
var soundEffectEnabled: bool

var musicVolume: float
var soundEffectVolume: float

var displayMode: bool = false

const BGMUSICBUS = "BGMusic"
const SFXBUS = "SFX"

func _setMusicVolume(value):
	var bus = AudioServer.get_bus_index(BGMUSICBUS)
	if value == 0:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, linear2db(value))

func _setSFXVolume(value):
	var bus = AudioServer.get_bus_index(SFXBUS)
	if value == 0:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, linear2db(value))
