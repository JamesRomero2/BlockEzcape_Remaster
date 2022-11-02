extends Node

onready var buttonGroup = $MainMenuContainer/MainMenuUI/Buttons/ButtonGroup
onready var settings = $MainMenuContainer/Settings
onready var exitPanel := $MainMenuContainer/ExitPanel
onready var resetWarning := $MainMenuContainer/ResetSaves
onready var resetButtonGroup := $MainMenuContainer/ResetSaves/NinePatchRect/VBoxContainer/ButtonGroup

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
	
	for button in resetButtonGroup.get_children():
		button.connect("buttonPressed", self, "_resetPanelDecision")

func _buttonPressed(name):
	match name:
		"Continue":
			SceneTransition._changeScene(worldMapScene)
		"NewGame":
			_newGame()
		"Settings":
			settings.visible = true
			$MainMenuContainer/MainMenuUI.visible = false
			print(GameManager._getOpenLevels())
		"Credits":
			SceneTransition._changeScene(creditsScene)
		"Exit":
			exitPanel.visible = true

func _onBackButton(name):
	settings.visible = false
	$MainMenuContainer/MainMenuUI.visible = true

func _newGame():
	if GameManager._getOpenLevels().size() > 1:
		resetWarning.visible = true
	else:
		SceneTransition._changeScene(cutsceneStart)


func _resetPanelDecision(name):
	match name:
		"Yes":
			GameManager._resetLevels()
			SceneTransition._changeScene(cutsceneStart)
		"No":
			resetWarning.visible = false
