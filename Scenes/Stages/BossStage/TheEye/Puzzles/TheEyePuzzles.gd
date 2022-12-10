extends Node

signal setDone

onready var camera := $Camera2D
onready var rand := RandomNumberGenerator.new()
onready var noise := OpenSimplexNoise.new()

onready var board := $Board
onready var player := $Board/Player
onready var temple := $Board/Temple
onready var trap := $Board/Traps
onready var canUndoTime := $Timers/CanUndoTimer
onready var spawnTime := $Timers/SpawningCavTimer
onready var venomFog := $Death/ColorRect
onready var deathScreen := $Death/DeathScreen
onready var healTimer := $Timers/IncreaseHealth
onready var resetButton := $Death/DeathScreen/HBoxContainer/Reset
onready var quitButton := $Death/DeathScreen/HBoxContainer/Quit

export var answers := {
	0: null,
	1: null,
	2: null,
	3: null,
}
export(String) var introTimelineName = ""
export(int) var numberOfTraps = 2
export(int) var spawnWaitTime = 2

export var randomShakeStrength: float = 10.0
export var shakeDecayRate: float = 3.0
export var noiseShakeSpeed: float = 10.0
export var noiseShakeStrength: float = 15.0

var moveCount: int = 0
var result = Array()
var undoRedoJournal: UndoRedo = UndoRedo.new()
var canUndo: bool = true
var noiseI: float = 0.0
var shakeStrength: float = 0.0

func _ready():
	rand.randomize()
	noise.seed = rand.randi()
	noise.period = 2
	
	spawnTime.wait_time = spawnWaitTime
	_connectSignal()
	_playDialog(introTimelineName)
	venomFog.material.set_shader_param("softness", 6)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func applyShake():
	shakeStrength = noiseShakeStrength

func _playDialog(value):
	if value == "":
		_playGame()
	else:
		if get_node_or_null('DialogNode') == null:
			GameManager._setGamePaused(true)
			GameManager._setGameOver(true)
			GameManager._setGameTimerActive(false)
			GameManager._setGameCutScenePlaying(true)
			var dialog = Dialogic.start(value)
			dialog.connect('timeline_end', self, '_dialogEnd')
			add_child(dialog)

func _dialogEnd(timeline_name):
	GameManager._setGameCutScenePlaying(false)
	_playGame()

func _playGame():
	GameManager._setGameOver(false)
	GameManager._setGamePaused(false)
	GameManager._setGameTimerActive(true)
	_cast()

func _connectSignal():
	player.connect("objectStateChange", self, "_playerJournal")
	player.connect("playerPushed", self, "_playerPushJournal")
	player.connect("playerDamage", self, "_onPlayerHurt")
	temple.connect("levelAccomplish", self, "_onLevelAccomplish")
	
	for child in board.get_children():
		if child.is_in_group("Box"):
			child.connect("boxMoves", self, "_boxJournal")
		
		if child.is_in_group("Symbols"):
			child.connect("boxMoves", self, "_operationalBoxJournal")
		
		if child.is_in_group("Bridge"):
			child.connect("UnwalkableState", self, "_onPhantomTileStateChange")
		
		if child.is_in_group("Reader"):
			child.connect("boxValue", self, "_onScannerInput")
			result.append(child._getResult())
		
		if child.is_in_group("Operational"):
			child.connect("operationalTileState", self, "_onOperationalStateChange")
	
	resetButton.connect("buttonPressed", self, "_on_Reset_buttonPressed")
	quitButton.connect("buttonPressed", self, "_on_Quit_buttonPressed")

func _process(delta):
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
					canUndoTime.start()

func _getAllBridgeState():
	var bridges := Array()
	bridges.clear()
	for child in board.get_children():
		if child.is_in_group("Bridge"):
			bridges.append(child._getPress())
	return bridges

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

func _onLevelAccomplish():
	emit_signal("setDone")

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

func _cast():
	if GameManager._getGameOver(): return
	if !GameManager._getPlayerAnimating():
		randomize()
		var children = trap.get_children()
		for i in numberOfTraps:
			var trapObject = children[randi() % children.size()]
			trapObject._setTargetPost((trapObject.position - player.position) * -1)
			trapObject._casting()
	spawnTime.start()

func _onPlayerHurt():
	var currentValue = venomFog.material.get_shader_param("softness")
	if currentValue > 0:
		venomFog.material.set_shader_param("softness", currentValue - 1)
		applyShake()
		healTimer.start()
		
	if (currentValue - 1) == 0:
		deathScreen.visible = true
		GameManager._setGameOver(true)
		GameManager._setGameTimerActive(!GameManager._getGameTimerActive())
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Reset_buttonPressed(buttonName):
	get_tree().reload_current_scene()

func _on_Quit_buttonPressed(buttonName):
	LoadingScreen.loadLevel("WorldMap")

func _on_IncreaseHealth_timeout():
	var currentValue = venomFog.material.get_shader_param("softness")
	if (currentValue - 1) < 5 and !GameManager._getGameOver() and !GameManager._getGamePause():
		venomFog.material.set_shader_param("softness", currentValue + 1)
		healTimer.start()
	else:
		healTimer.stop()

func _on_CanUndoTimer_timeout():
	canUndo = true

func _on_SpawningCavTimer_timeout():
	_cast()
