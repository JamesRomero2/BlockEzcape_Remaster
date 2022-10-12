extends Control

var mainMenuScene = preload("res://Scenes/MainMenu/MainMenu.tscn")

func _ready():
	GlobalSettings._setMusicVolume(0.5)
	GlobalSettings._setSFXVolume(0.5)

func _openMainMenu():
	var ERR = get_tree().change_scene_to(mainMenuScene)
	
	if ERR != OK:
		print("Something is wrong")
		get_tree().quit()
