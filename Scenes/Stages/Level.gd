extends Node

onready var player := $GameObjects/Player
onready var temple := $GameObjects/Temple
onready var pause := $PausePanel
onready var resultPanel := $ResultPanel
onready var rand := RandomNumberGenerator.new()
onready var noise := OpenSimplexNoise.new()
onready var camera := $Camera2D
onready var blackBoad := $WhiteBoard
onready var slides := $WhiteBoard/Control/Slides
onready var death := $Death
onready var deathFog := $Death/ColorRect
onready var deathScreen := $Death/DeathScreen
onready var healTimer := $HealTimer
onready var resetButton := $Death/DeathScreen/HBoxContainer/Reset
onready var quitButton := $Death/DeathScreen/HBoxContainer/Quit

export(Array, String) var timelines
export var answers := {
	0: null,
	1: null,
	2: null,
	3: null,
}
export(bool) var resultAnimating: bool = false
export(int, 0, 4) var requiredMedal = 0
export var randomShakeStrength: float = 10.0
export var shakeDecayRate: float = 3.0
export var noiseShakeSpeed: float = 10.0
export var noiseShakeStrength: float = 15.0

var moveCount: int = 0
var result = Array()
var time = 0
var secs
var mins
var undoRedoJournal: UndoRedo = UndoRedo.new()
var canUndo: bool = true
var forestMusic = load("res://Assets/Audio/Music/Forest/FinalForestLevelMusic.ogg")
var undergroundMusic = load("res://Assets/Audio/Music/Underground/FinalUndergroundLevelMusic.ogg")
var castleMusic = load("res://Assets/Audio/Music/Castle/FinalCastleLevelMusic.ogg")
var magicalMusic = load("res://Assets/Audio/Music/Magical/FinalMagicalLevelMusic.ogg")
var noiseI: float = 0.0
var shakeStrength: float = 0.0
var counter: int = 0
var timelinePlaying: int = 0
var slideCount : int = 0

func _ready():
	get_tree().current_scene = self
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	deathFog.material.set_shader_param("softness", 6)
	_playDialog()
	_connectSignal()
	levelMusicManager()
	closePresentation()
	hideAllSlide()

	rand.randomize()
	noise.seed = rand.randi()
	noise.period = 2

func _playDialog():
	if timelines.empty():
		_playGame()
	else:
		if get_node_or_null('DialogNode') == null:
			GameManager._setGameDialogPlaying(true)
			GameManager._setGamePaused(true)
			GameManager._setGameOver(true)
			GameManager._setGameTimerActive(false)
			var dialog = Dialogic.start(timelines[timelinePlaying])
			dialog.connect('timeline_end', self, '_dialogEnd')
			dialog.connect('dialogic_signal', self, 'dialogicSignals')
			add_child(dialog)

func _dialogEnd(timeline_name):
	dialogSetEnded()

func dialogSetEnded():
	if timelinePlaying < (timelines.size() - 1):
		timelinePlaying += 1
		_playDialog()
	else:
		_playGame()
		closePresentation()

func _playGame():
	GameManager._setGameDialogPlaying(false)
	GameManager._setGameOver(false)
	GameManager._setGamePaused(false)
	GameManager._setGameTimerActive(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if get_node_or_null("GameObjects/Traps") != null: 
		get_node_or_null("GameObjects/Traps")._cast()

func _connectSignal():
	player.connect("objectStateChange", self, "_playerJournal")
	player.connect("playerPushed", self, "_playerPushJournal")
	player.connect("playerDamage", self, "_onPlayerHurt")
	temple.connect("levelAccomplish", self, "_onLevelAccomplish")
	resetButton.connect("buttonPressed", self, "_on_Reset_buttonPressed")
	quitButton.connect("buttonPressed", self, "_on_Quit_buttonPressed")
	healTimer.connect("timeout", self, "_on_HealTimer_timeout")
	
	for box in get_tree().get_nodes_in_group("Box"):
		box.connect("boxMoves", self, "_boxJournal")
	
	for symbol in get_tree().get_nodes_in_group("Symbols"):
		symbol.connect("boxMoves", self, "_operationalBoxJournal")
	
	for phantom in get_tree().get_nodes_in_group("Bridge"):
		phantom.connect("UnwalkableState", self, "_onPhantomTileStateChange")
	
	for scanner in get_tree().get_nodes_in_group("Reader"):
		scanner.connect("boxValue", self, "_onScannerInput")
		result.append(scanner._getResult())
	
	for operational in get_tree().get_nodes_in_group("Operational"):
		operational.connect("operationalTileState", self, "_onOperationalStateChange")

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("escape") and !GameManager._getGameOver():
			_changeGameState()
		if GameManager._getGameDialogPlaying() and event.is_action_pressed("skip"):
				var dialog = self.get_child(get_child_count() - 1)
				if dialog.get_child(0).name == "DialogNode":
					var dialogNode = dialog.get_child(0)
					dialogNode.queue_free()
					dialogSetEnded()
				else:
					print("No Dialog Node")

func _process(delta):
	_gameTimer(delta)

	if Input.is_action_pressed("undo"):
		_undoSystem()
	
	shakeStrength = lerp(shakeStrength, 0, shakeDecayRate * delta)
	
	camera.offset = getNoiseOffset(delta)

func getNoiseOffset(delta):
	noiseI += delta * noiseShakeSpeed
	
	return Vector2(
		noise.get_noise_2d(1, noiseI) * shakeStrength,
		noise.get_noise_2d(100, noiseI) * shakeStrength
	)

func _gameTimer(value):
	if GameManager._getGameTimerActive() and !GameManager._getPlayerAnimating():
		time += value
	
	secs = fmod(time, 60)
	mins = fmod(time, 60 * 60) / 60
	
	if int(mins) == 7:
		death.visible = true
		deathFog.material.set_shader_param("softness", 0)
		deathScreen.visible = true
		GameManager._setGameOver(true)
		GameManager._setGameTimerActive(!GameManager._getGameTimerActive())
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true

func _onPhantomTileStateChange():
	for unWalkable in get_tree().get_nodes_in_group("Unwalkable"):
		if _getAllBridgeState().has(true):
			unWalkable._setDisableToTrue()
		else:
			unWalkable._setDisableToFalse()

func _onScannerInput(value, id, scannerNode):
	result.clear()

	var valueString = str(value)

	for crystal in get_tree().get_nodes_in_group("Crystal"):
		if id == crystal.scannerID:
			if valueString == "Null":
				crystal._crystalHasValue(false, value)
			else:
				crystal._crystalHasValue(true, value)

	for answerId in answers.size():
		if answers[answerId] != null:
			if answerId == id:
				if valueString == str(answers[answerId]):
					scannerNode._setResult(true)
				else:
					scannerNode._setResult(false)

	for scanner in get_tree().get_nodes_in_group("Reader"):
		result.append(scanner._getResult())

	if result.has(false):
		temple._setAnswer(false)
		temple._setDoorState(false)
		temple.call_deferred("_setTexture")
	else:
		temple._setAnswer(true)
		temple._setDoorState(true)
		temple.call_deferred("_setTexture")

func _getAllBridgeState():
	var bridges := Array()
	bridges.clear()
	for bridgeButton in get_tree().get_nodes_in_group("Bridge"):
		bridges.append(bridgeButton._getPress())
	return bridges

func _changeGameState():
	GameManager._setGameTimerActive(!GameManager._getGameTimerActive())
	GameManager._setGamePaused(!GameManager._getGamePause())
	pause.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_unhandled_input(false)
	get_tree().paused = true

func _onLevelAccomplish():
	GameManager._setGameOver(true)
	GameManager._setGameTimerActive(!GameManager._getGameTimerActive())
	resultPanel._showResult(mins, secs, self.name.right(5).to_int(), requiredMedal)

func _playerJournal(object):
	undoRedoJournal.create_action("Move")
	undoRedoJournal.add_undo_method(object, "undoMovement")

	undoRedoJournal.commit_action()

func _playerPushJournal(object):
	undoRedoJournal.create_action("Pushing")
	undoRedoJournal.add_undo_method(object, "undoMovement")

	undoRedoJournal.commit_action()

func _boxJournal(object):
	undoRedoJournal.create_action("Pushed")
	undoRedoJournal.add_undo_method(object, "undoBoxPosition")
	undoRedoJournal.add_undo_method(object, "undoBoxValue", object.boxValue)

	undoRedoJournal.commit_action()

func _operationalBoxJournal(object):
	undoRedoJournal.create_action("Pushed")
	undoRedoJournal.add_undo_method(object, "undoBoxPosition")
	
	undoRedoJournal.commit_action()

func _onOperationalStateChange(object):
	undoRedoJournal.create_action("Operational Added")
	undoRedoJournal.add_undo_method(object, "_undoOperationalTile")
	
	undoRedoJournal.commit_action()

func _on_Timer_timeout():
	canUndo = true

func _undoSystem():
	if !GameManager._getGameOver():
		if !player.moving:
			if canUndo:
				if undoRedoJournal.has_undo():
					match undoRedoJournal.get_current_action_name():
						"Move":
							undoRedoJournal.undo()
						"Pushing":
							for i in 2:	
								undoRedoJournal.undo()
						"Operational Added":
							for i in 3:	
								undoRedoJournal.undo()
					canUndo = false
					$Timer.start()

func levelMusicManager():
	var levelNum = self.name.right(5).to_int()
	if levelNum > 0 and levelNum < 5:
		GlobalMusic._changeMusic(forestMusic)
	elif levelNum > 5 and levelNum < 10:
		GlobalMusic._changeMusic(undergroundMusic)
	elif levelNum > 10 and levelNum < 15:
		GlobalMusic._changeMusic(castleMusic)
	elif levelNum > 15 and levelNum < 20:
		GlobalMusic._changeMusic(magicalMusic)

func _onPlayerHurt():
	applyShake()
	var currentValue = deathFog.material.get_shader_param("softness")
	if currentValue > 0:
		deathFog.material.set_shader_param("softness", currentValue - 1)
		healTimer.start()

	if (currentValue - 1) == 0:
		deathScreen.visible = true
		GameManager._setGameOver(true)
		GameManager._setGameTimerActive(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true

func applyShake():
	shakeStrength = noiseShakeStrength

func dialogicSignals(signalName):
	if slides.get_children().empty(): return
	hideAllSlide()
	
	if signalName == "open":
		openPresentation()
		openNextSlide(slideCount)
	if signalName == "close":
		closePresentation()
	if signalName == "slide":
		slideCount += 1
		openNextSlide(slideCount)
	if signalName == "reset":
		slideCount = 0
		openNextSlide(slideCount)

func hideAllSlide():
	for slide in slides.get_children():
		slide.visible = false

func openPresentation():
	blackBoad.visible = true

func closePresentation():
	blackBoad.visible = false

func openNextSlide(value):
	slides.get_child(value).visible = true

func _on_HealTimer_timeout():
	var currentValue = deathFog.material.get_shader_param("softness")
	if (currentValue - 1) < 5 and !GameManager._getGameOver() and !GameManager._getGamePause():
		deathFog.material.set_shader_param("softness", currentValue + 1)
		healTimer.start()
	else:
		healTimer.stop()

func _on_Reset_buttonPressed(buttonName):
	get_tree().reload_current_scene()

func _on_Quit_buttonPressed(buttonName):
	LoadingScreen.loadLevel("WorldMap")
	
