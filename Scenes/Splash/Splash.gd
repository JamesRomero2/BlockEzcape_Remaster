extends Control

var mainMenuScene = preload("res://Scenes/MainMenu/MainMenu.tscn")

func _openMainMenu():
	var ERR = get_tree().change_scene_to(mainMenuScene)
	
	if ERR != OK:
		print("Something is wrong")
		get_tree().quit()
