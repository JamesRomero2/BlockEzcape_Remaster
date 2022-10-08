extends Control

onready var animation := $AnimationPlayer

var mainMenuScene = load("res://Scenes/MainMenu/MainMenu.tscn")

func _input(event):
	if event.is_action_pressed("space"):
		animation.play("CreditsOut")

func _openMainMenu():
	var ERR = get_tree().change_scene_to(mainMenuScene)
	
	if ERR != OK:
		print("Something is wrong")
		get_tree().quit()
