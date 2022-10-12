extends Node

onready var music = $AudioStreamPlayer

func _ready():
	GlobalSettings._setMusicVolume(0.5)
	GlobalSettings._setSFXVolume(0.5)

func _changeMusic(value):
	music.stream = value
	music.play()

func _muteMusic():
	music.stop()

func _playMusic():
	music.play()

func _getMusic():
	return music.stream.resource_path
