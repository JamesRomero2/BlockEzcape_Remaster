extends Node

onready var displayModeButton = $MainMenuNavigation/Control/VBoxContainer2/Display/DisplayModeButton
onready var pause = $MainMenuNavigation

var mapMusic = load("res://Assets/Audio/Music/Music1.ogg")
var forestBG = load("res://Assets/Textures/Mountains5.png")
var undergroundBG = load("res://Assets/Textures/caveBG.jpg")

func _ready():
	GlobalMusic._changeMusic(mapMusic)
	$MainMenuNavigation/Control/VBoxContainer2/Music/MusicVolume.value = GlobalSettings.musicVolume
	$MainMenuNavigation/Control/VBoxContainer2/SoundEffects/SFXVolume.value = GlobalSettings.soundEffectVolume
	_windowsButtonToggle()
	_connectSignals()

func _connectSignals():
	for areas in get_tree().get_nodes_in_group("BGChangerArea"):
		areas.connect("enteredArea", self, "_changeBackground")

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("escape"):
			_changeGameState()

func _on_Unpause_pressed():
	if pause.visible:
		GameManager._setGamePaused(false)
		pause.visible = !pause.visible

func _on_MapButton_pressed():
	_on_Unpause_pressed()
	SceneTransition._changeScene("res://Scenes/MainMenu/MainMenu.tscn")

func _on_DisplayModeButton_pressed():
	GlobalSettings.displayMode = !GlobalSettings.displayMode
	GlobalSettings._setWindowDisplay(GlobalSettings.displayMode)
	_windowsButtonToggle()

func _windowsButtonToggle():
	if GlobalSettings.displayMode:
		displayModeButton.text = "FULLSCREEN"
	elif !GlobalSettings.displayMode:
		displayModeButton.text = "WINDOWED"

func _on_MusicVolume_value_changed(value):
	GlobalSettings._setMusicVolume(value)

func _on_SFXVolume_value_changed(value):
	GlobalSettings._setSFXVolume(value)

func _changeGameState():
	GameManager._setGamePaused(!GameManager._getGamePause())
	pause.visible = !pause.visible

func _changeBackground(areas):
	var tween = $CanvasLayer/WorldMapUI/Tween
	
	for bg in $CanvasLayer/WorldMapUI/Backgrounds.get_children():
		bg.visible = false
		tween.interpolate_property(
			bg, 
			"modulate:a", 
			1, 
			0, 
			.5, 
			Tween.TRANS_LINEAR, 
			Tween.EASE_IN_OUT)
		
		if bg.name == areas:
			tween.interpolate_property(
				bg, 
				"modulate:a", 
				0, 
				1, 
				.5, 
				Tween.TRANS_LINEAR, 
				Tween.EASE_IN_OUT)
			bg.visible = true
	tween.start()