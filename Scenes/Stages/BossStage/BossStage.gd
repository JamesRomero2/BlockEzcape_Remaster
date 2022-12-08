extends Node

export(PackedScene) var set1
export(PackedScene) var set2
export(PackedScene) var set3
export(int, 0, 4) var requiredMedal = 0
export(String) var bossEndingTimeline = ""

onready var pause := $PausePanel
onready var resultPanel := $ResultPanel
onready var animation := $AnimationPlayer
onready var stageArea := $StageArea
onready var bg := $BackgroundLayer/TextureRect

var set: int = 0
var puzzleSets = Array()
var time = 0
var secs
var mins
var forestBossMusic = load("res://Assets/Audio/Music/Forest/FinalForestBossLevelMusic.ogg")
var undergroundBossMusic = load("res://Assets/Audio/Music/Underground/FinalUndergroundBossLevelMusic.ogg")
var dungeonBossMusic = load("res://Assets/Audio/Music/Castle/FinalCastleBossLevelMusic.ogg")
var magicalBossMusic = load("res://Assets/Audio/Music/Magical/FinalMagicalBossLevelMusic.ogg")
var undergroundBG = load("res://Assets/Textures/LevelBG/Underground/9.jpg")
var ruinsBG = load("res://Assets/Textures/LevelBG/Ruins/3.jpg")
var magicalBG = load("res://Assets/Textures/LevelBG/MagicalVoid/8.jpg")
var portalBG = load("res://Assets/Textures/LevelBG/portalWorld.jpg")
var fieldsBG = load("res://Assets/Textures/LevelBG/fields.jpg")

func _ready():
	GlobalMusic._changeMusic(setBossStageBGMusic())
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	puzzleSets = [set1, set2, set3]
	_setPuzzle()

func setBossStageBGMusic():
	var music
	match self.name.right(5).to_int():
		5:
			music = forestBossMusic
		10:
			music = undergroundBossMusic
		15:
			music = dungeonBossMusic
		20:
			music = magicalBossMusic
	return music

func _process(delta):
	_gameTimer(delta)

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("escape") and !GameManager._getGameOver():
			_changeGameState()

func _changeGameState():
	GameManager._setGameTimerActive(!GameManager._getGameTimerActive())
	GameManager._setGamePaused(!GameManager._getGamePause())
	pause.visible = !pause.visible
	set_process_unhandled_input(false)
	get_tree().paused = !get_tree().paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _gameTimer(value):
	if GameManager._getGameTimerActive() and !GameManager._getPlayerAnimating():
		time += value
	
	secs = fmod(time, 60)
	mins = fmod(time, 60 * 60) / 60

func _setPuzzle():
	print("Setting Puzzle...")
	
	if puzzleSets.has(""):
		print("Please Set all Puzzle")
		
	animation.play("Transition")
	yield(animation, "animation_finished")
	
	if stageArea.get_child_count() > 0:
		for node in stageArea.get_children():
			node.queue_free()
	
	var instanceSet = puzzleSets[set].instance()
	instanceSet.connect("setDone", self, "_setComplete")
	stageArea.call_deferred("add_child", instanceSet)
		
	animation.play_backwards("Transition")

	GameManager._setGamePaused(false)
	GameManager._setGameTimerActive(true)

func _changeSet():
	if set >= 0 and set < 2:
		GameManager._setGamePaused(true)
		GameManager._setGameTimerActive(false)
		print("Changing Set...")
		set += 1
		_setPuzzle()
	else:
		_onLevelAccomplish()

func _onLevelAccomplish():
	GameManager._setGameOver(true)
	GameManager._setGameTimerActive(!GameManager._getGameTimerActive())
	stageArea.call_deferred("queue_free")
	if get_node_or_null('DialogNode') == null:
		GameManager._setGamePaused(true)
		GameManager._setGameOver(true)
		GameManager._setGameTimerActive(false)
		var dialog = Dialogic.start(bossEndingTimeline)
		dialog.connect('timeline_end', self, '_dialogEnd')
		dialog.connect("dialogic_signal", self, "_dialogic_signal")
		add_child(dialog)

func _dialogEnd(timeline_name):
	resultPanel._showResult(mins, secs, self.name.right(5).to_int(), requiredMedal)

func _dialogic_signal(signalName):
	match signalName:
		"changeBGtoUnderground":
			bg.texture = undergroundBG
		"changeBGtoCastle":
			bg.texture = ruinsBG
		"changeBGtoMagical":
			bg.texture = magicalBG
		"changeBGtoPortal":
			bg.texture = portalBG
		"changeBGtoRealWorld":
			bg.texture = fieldsBG

func _setComplete():
	_changeSet()


