extends Node

onready var buttonGroup = $MainMenuContainer/MainMenuUI/Buttons/ButtonGroup
onready var settings = $MainMenuContainer/Settings
onready var exitPanel := $MainMenuContainer/ExitPanel
onready var resetWarning := $MainMenuContainer/ResetSaves
onready var resetButtonGroup := $MainMenuContainer/ResetSaves/NinePatchRect/VBoxContainer/ButtonGroup

var mainMenuBGMusic = "res://Assets/Audio/Music/space-120280.mp3"

func _ready():
	if mainMenuBGMusic != GlobalMusic._getMusic():
		GlobalMusic._changeMusic(load(mainMenuBGMusic))
	_connectSignals()

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("activateDemo"):
			activateDemo()

func _connectSignals():
	buttonGroup.connect("buttonPressedName", self, "_buttonPressed")
	settings.backButton.connect("buttonPressed", self, "_onBackButton")

	for button in resetButtonGroup.get_children():
		button.connect("buttonPressed", self, "_resetPanelDecision")

func _buttonPressed(name):
	match name:
		"Continue":
			LoadingScreen.loadLevel("WorldMap")
		"NewGame":
			_newGame()
		"Settings":
			settings.visible = true
			$MainMenuContainer/MainMenuUI.visible = false
		"Credits":
			LoadingScreen.loadLevel("Credits")
		"Exit":
			exitPanel.visible = true

func _onBackButton(name):
	settings.visible = false
	$MainMenuContainer/MainMenuUI.visible = true

func _newGame():
	if GameManager._getOpenLevels().size() > 1:
		resetWarning.visible = true
	else:
		LoadingScreen.loadLevel("Level 00")

func _resetPanelDecision(name):
	match name:
		"Yes":
			GameManager._resetLevels()
			LoadingScreen.loadLevel("Level 00")
		"No":
			resetWarning.visible = false

func activateDemo():
	GameManager._openAllLevels()
