extends Control

var mainMenuScene = "res://Scenes/MainMenu/MainMenu.tscn"
var creditsBGMusic = load("res://Assets/Audio/Music/space-ambient-sci-fi-121842.mp3")

func _ready():
	GlobalMusic._changeMusic(creditsBGMusic)

func _input(event):
	if event.is_action_pressed("space"):
		SceneTransition._changeScene(mainMenuScene)
