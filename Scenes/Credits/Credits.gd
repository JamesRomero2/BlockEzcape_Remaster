extends Control

onready var animation := $AnimationPlayer

var mainMenuScene = load("res://Scenes/MainMenu/MainMenu.tscn")
var creditsBGMusic = load("res://Assets/Audio/Music/space-ambient-sci-fi-121842.mp3")

func _ready():
	GlobalMusic._changeMusic(creditsBGMusic)

func _input(event):
	if event.is_action_pressed("space"):
		animation.play("CreditsOut")

func _openMainMenu():
	var ERR = get_tree().change_scene_to(mainMenuScene)
	
	if ERR != OK:
		print("Something is wrong")
		get_tree().quit()
