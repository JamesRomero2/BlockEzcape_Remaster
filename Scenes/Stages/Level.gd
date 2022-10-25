extends Node

onready var themeColor := $BackgroundLayer/Color
onready var player := $GameObjects/Player
onready var temple := $GameObjects/Temple
onready var pause := $PausePanel

export(Color) var colorTheme
export var answers := {
	0: null,
	1: null,
	2: null,
	3: null,
}
export(bool) var resultAnimating: bool = false

var moveCount: int = 0
var result = Array()
var time = 0
var timerActive = false
var timeSpent: String

var gameJournal = {}
var objectJournal = Array()
var stateCounter: int = 0

var undoRedoJournal: UndoRedo = UndoRedo.new()
var canUndo: bool = true

func _ready():
	GameManager._setGameOver(false)
	_changeTheme()
	_connectSignal()
	timerActive = true

func _connectSignal():
	player.connect("objectStateChange", self, "_playerJournal")
	temple.connect("levelAccomplish", self, "_onLevelAccomplish")
	
	for box in get_tree().get_nodes_in_group("Box"):
		box.connect("boxMoves", self, "_boxJournal")
	
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
		if event.is_action_pressed("space"):
			if GameManager._getGameOver() and !resultAnimating:
				SceneTransition._changeScene("res://Scenes/WorldMap/WorldMap.tscn")

func _process(delta):
	if timerActive:
		time += delta
	
	var milliSecs = fmod(time, 1) * 1000
	var secs = fmod(time, 60)
	var mins = fmod(time, 60 * 60) / 60
	var hours = fmod(fmod(time, 3600 * 60) / 3600, 24)
	
	timeSpent = "%02d : %02d : %02d : %03d" % [hours, mins, secs, milliSecs]
	
	if Input.is_action_pressed("undo"):
		_undoSystem()

func _changeTheme():
	themeColor.color = colorTheme

func _onPhantomTileStateChange():
	for unWalkable in get_tree().get_nodes_in_group("Unwalkable"):
		if _getAllBridgeState().has(true):
			unWalkable._setDisableToTrue()
		else:
			unWalkable._setDisableToFalse()

func _onScannerInput(value, id, scannerNode):
	result.clear()
	
	for card in get_tree().get_nodes_in_group("Card"):
		if value == null:
			card._checkID(id, value, false)
		else:
			card._checkID(id, value, true)
	
	for answerId in answers.size():
		if answers[answerId] != null:
			if answerId == id:
				if str(value) == str(answers[answerId]):
					scannerNode._setResult(true)
				else:
					scannerNode._setResult(false)
	
	for scanner in get_tree().get_nodes_in_group("Reader"):
		result.append(scanner._getResult())
	
	if result.has(false):
		$GameObjects.find_node("Temple")._setAnswer(false)
		$GameObjects.find_node("Temple")._setDoorState(false)
	else:
		$GameObjects.find_node("Temple")._setAnswer(true)
		$GameObjects.find_node("Temple")._setDoorState(true)

func _getAllBridgeState():
	var bridges := Array()
	bridges.clear()
	for bridgeButton in get_tree().get_nodes_in_group("Bridge"):
		bridges.append(bridgeButton._getPress())
	return bridges

func _changeGameState():
	timerActive = !timerActive
	GameManager._setGamePaused(!GameManager._getGamePause())
	pause.visible = !pause.visible

func _onLevelAccomplish():
	GameManager._setGameOver(true)
	timerActive = false
	$ResultLayer.visible = !$ResultLayer.visible
	$ResultLayer/Control/Control/Label2.text = timeSpent
	$ResultLayer/AnimationPlayer.play("ResultAnimation")

func _playerJournal(object):
	undoRedoJournal.create_action("Player Move")
	undoRedoJournal.add_undo_method(object, "undoMovement")

	undoRedoJournal.commit_action()

func _boxJournal(object):
	undoRedoJournal.create_action("Box Move")
	undoRedoJournal.add_undo_method(object, "undoBoxPosition")
	undoRedoJournal.add_undo_method(object, "undoBoxValue", object.boxValue)

	undoRedoJournal.commit_action()

func _onOperationalStateChange(object):
	undoRedoJournal.create_action("Operational Tile Change State")
	undoRedoJournal.add_undo_method(object, "_undoOperationalTile")
	
	undoRedoJournal.commit_action()

func _on_PauseButton_pressed():
	_changeGameState()

func _on_Timer_timeout():
	canUndo = true

func _on_UndoButton_pressed():
	_undoSystem()

func _undoSystem():
	if !GameManager._getGameOver():
		if !player.moving:
			if canUndo:
				if undoRedoJournal.has_undo():
					print(undoRedoJournal.get_current_action_name())
					undoRedoJournal.undo()
					canUndo = false
					$Timer.start()
