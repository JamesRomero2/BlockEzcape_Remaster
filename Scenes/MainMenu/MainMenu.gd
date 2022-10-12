extends Node

onready var buttonGroup = $MainMenuUI/Buttons/ButtonGroup
onready var settings = $Settings
onready var exitPanel := $ExitPanel

var creditsScene = preload("res://Scenes/Credits/Credits.tscn")
var mainMenuBGMusic = "res://Assets/Audio/Music/space-120280.mp3"

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
			print("NewGame Button Pressed")
		"Settings":
			$Settings.visible = true
			$MainMenuUI.visible = false
		"Credits":
			_openCredits()
		"Exit":
			exitPanel.visible = true

func _openCredits():
	var ERR = get_tree().change_scene_to(creditsScene)
	
	if ERR != OK:
		print("Something is wrong")
		get_tree().quit()

func _onBackButton(name):
	$Settings.visible = false
	$MainMenuUI.visible = true
