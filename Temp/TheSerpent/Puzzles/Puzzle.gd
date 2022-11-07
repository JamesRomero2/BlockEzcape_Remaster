extends Node2D

signal setDone

onready var player := $Player
onready var temple := $Temple
onready var trap := $Traps
onready var spawnTime := $SpawningVenomTimer

export var answers := {
	0: null,
	1: null,
	2: null,
	3: null,
}
export(String) var introTimelineName = ""
export(int) var numberOfTraps = 2
export(int) var spawnWaitTime = 2

var moveCount: int = 0
var result = Array()
var undoRedoJournal: UndoRedo = UndoRedo.new()
var canUndo: bool = true

func _ready():
	spawnTime.wait_time = spawnWaitTime
	_connectSignal()
	_playDialog(introTimelineName)
	_castVenom()

func _playDialog(value):
	if value == "":
		_playGame()
#		just play the game
	else:
#		play Dialog
		if get_node_or_null('DialogNode') == null:
			GameManager._setGamePaused(true)
			GameManager._setGameOver(true)
			GameManager._setGameTimerActive(false)
			var dialog = Dialogic.start(value)
			dialog.connect('timeline_end', self, '_dialogEnd')
			add_child(dialog)

func _dialogEnd(timeline_name):
	_playGame()

func _playGame():
	GameManager._setGameOver(false)
	GameManager._setGamePaused(false)
	GameManager._setGameTimerActive(true)

func _connectSignal():
	player.connect("objectStateChange", self, "_playerJournal")
	player.connect("playerPushed", self, "_playerPushJournal")
	temple.connect("levelAccomplish", self, "_onLevelAccomplish")
	
	for child in self.get_children():
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

func _process(delta):
	if Input.is_action_pressed("undo"):
		_undoSystem()

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

func _getAllBridgeState():
	var bridges := Array()
	bridges.clear()
	for child in self.get_children():
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
	else:
		temple._setAnswer(true)
		temple._setDoorState(true)

func _on_Timer_timeout():
	canUndo = true

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

func _castVenom():
	randomize()
	var children = trap.get_children()
	for i in numberOfTraps:
		var trapObject = children[randi() % children.size()]
		if !trapObject.playing:
			trapObject._castingVenom()
	spawnTime.start()

func _on_SpawningVenomTimer_timeout():
	_castVenom()
