extends Node

onready var music = $AudioStreamPlayer

var musicPos = 0

func _changeMusic(value):
	music.stream = value
	music.play()

func _muteMusic():
	music.stop()

func _playMusic():
	music.play()

func _getMusic():
	return music.stream.resource_path

func _pauseMusic():
	musicPos = music.get_playback_position()
	music.stop()

func _unPauseMusic():
	music.play(musicPos)
