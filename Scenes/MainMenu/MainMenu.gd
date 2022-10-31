extends Node

onready var buttonGroup = $MainMenuContainer/MainMenuUI/Buttons/ButtonGroup
onready var settings = $MainMenuContainer/Settings
onready var exitPanel := $MainMenuContainer/ExitPanel

var creditsScene = "res://Scenes/Credits/Credits.tscn"
var worldMapScene = "res://Scenes/WorldMap/WorldMap.tscn"
var mainMenuBGMusic = "res://Assets/Audio/Music/space-120280.mp3"
var cutsceneStart = "res://Scenes/CutScenes/Intro/Intro.tscn"

func _ready():
	if mainMenuBGMusic != GlobalMusic._getMusic():
		GlobalMusic._changeMusic(load(mainMenuBGMusic))
	_connectSignals()

func _connectSignals():
	buttonGroup.connect("buttonPressedName", self, "_buttonPressed")
	settings.backButton.connect("buttonPressed", self, "_onBackButton")

func _buttonPressed(name):
	match name:
		"Continue":
			print("Continue Button Pressed")
		"NewGame":
			SceneTransition._changeScene(cutsceneStart)
		"Settings":
			settings.visible = true
			$MainMenuContainer/MainMenuUI.visible = false
		"Credits":
			SceneTransition._changeScene(creditsScene)
		"Exit":
			exitPanel.visible = true

func _onBackButton(name):
	settings.visible = false
	$MainMenuContainer/MainMenuUI.visible = true
