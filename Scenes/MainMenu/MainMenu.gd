extends Node

onready var buttonGroup = $MainMenuUI/Buttons/ButtonGroup
onready var settings = $Settings

var creditsScene = preload("res://Scenes/Credits/Credits.tscn")

func _ready():
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
		"HowToPlay":
			print("HowToPlay Button Pressed")
		"Settings":
			$Settings.visible = true
		"Credits":
			_openCredits()
		"Exit":
			get_tree().quit()
	$MainMenuUI.visible = false

func _openCredits():
	var ERR = get_tree().change_scene_to(creditsScene)
	
	if ERR != OK:
		print("Something is wrong")
		get_tree().quit()

func _onBackButton(name):
	$Settings.visible = false
	$MainMenuUI.visible = true
