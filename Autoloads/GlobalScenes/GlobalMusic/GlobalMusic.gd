extends Node

onready var music = $AudioStreamPlayer

func _changeMusic(value):
	music.stream = value
	music.play()

func _muteMusic():
	music.stop()

func _playMusic():
	music.play()
