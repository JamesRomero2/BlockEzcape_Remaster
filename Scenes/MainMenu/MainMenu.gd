extends Node

onready var buttonGroup = $MainMenuContainer/MainMenuUI/Buttons/ButtonGroup
onready var settings = $MainMenuContainer/Settings
onready var exitPanel := $MainMenuContainer/ExitPanel
onready var resetWarning := $MainMenuContainer/ResetSaves
onready var resetButtonGroup := $MainMenuContainer/ResetSaves/NinePatchRect/VBoxContainer/ButtonGroup
onready var demoButtonGroup := $DemoPanel/Control/NinePatchRect/VBoxContainer/ButtonGroup
onready var demoPanel := $DemoPanel

var mainMenuBGMusic = load("res://Assets/Audio/Music/MainMenuMusic.ogg")

func _ready():
	GlobalMusic._changeMusic(mainMenuBGMusic)
	_connectSignals()

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("activateDemo"):
			demoPanel.visible = true

func _connectSignals():
	buttonGroup.connect("buttonPressedName", self, "_buttonPressed")
	settings.backButton.connect("buttonPressed", self, "_onBackButton")

	for button in resetButtonGroup.get_children():
		button.connect("buttonPressed", self, "_resetPanelDecision")
	
	for button in demoButtonGroup.get_children():
		button.connect("buttonPressed", self, "demoActivation")

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

func demoActivation(name):
	match name:
		"Yes":
			demoPanel.visible = false
			activateDemo()
			get_tree().set_current_scene(self)
			get_tree().reload_current_scene()
		"No":
			demoPanel.visible = false
