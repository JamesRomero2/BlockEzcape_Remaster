extends Node

var mapMusic = load("res://Assets/Audio/Music/Music1.ogg")

func _ready():
	GlobalMusic._changeMusic(mapMusic)
