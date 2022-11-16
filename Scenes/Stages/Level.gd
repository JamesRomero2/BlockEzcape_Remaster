extends Node

onready var player := $GameObjects/Player
onready var temple := $GameObjects/Temple
onready var pause := $PausePanel
onready var resultPanel := $ResultPanel

export(String) var timelineName = ""
export var answers := {
	0: null,
	1: null,
	2: null,
	3: null,
}
export(bool) var resultAnimating: bool = false
export(int, 0, 4) var requiredMedal = 0

var moveCount: int = 0
var result = Array()
var time = 0
var secs
var mins
var undoRedoJournal: UndoRedo = UndoRedo.new()
var canUndo: bool = true
var playingDialog: bool = false
var forestMusic = load("res://Assets/Audio/Music/Forest/FinalForestLevelMusic.ogg")
var undergroundMusic = load("res://Assets/Audio/Music/Underground/FinalUndergroundLevelMusic.ogg")
var castleMusic = load("res://Assets/Audio/Music/Castle/FinalCastleLevelMusic.ogg")
var magicalMusic = load("res://Assets/Audio/Music/Magical/FinalMagicalLevelMusic.ogg")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_playDialog(timelineName)
	_connectSignal()
	levelMusicManager()

func _playDialog(value):
	if value == "":
		_playGame()
	else:
		if get_node_or_null('DialogNode') == null:
			playingDialog = true
			GameManager._setGamePaused(true)
			GameManager._setGameOver(true)
			GameManager._setGameTimerActive(false)
			var dialog = Dialogic.start(value)
			dialog.connect('timeline_end', self, '_dialogEnd')
			add_child(dialog)

func _dialogEnd(timeline_name):
	_playGame()

func _playGame():
	playingDialog = false
	GameManager._setGameOver(false)
	GameManager._setGamePaused(false)
	GameManager._setGameTimerActive(true)

func _connectSignal():
	player.connect("objectStateChange", self, "_playerJournal")
	player.connect("playerPushed", self, "_playerPushJournal")
	temple.connect("levelAccomplish", self, "_onLevelAccomplish")
	
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
		if playingDialog and event.is_action_pressed("skip"):
				var dialog = self.get_child(get_child_count() - 1)
				if dialog.get_child(0).name == "DialogNode":
					var dialogNode = dialog.get_child(0)
					dialogNode.queue_free()
					_playGame()
				else:
					print("No Dialog Node")

func _process(delta):
	_gameTimer(delta)

	if Input.is_action_pressed("undo"):
		_undoSystem()

func _gameTimer(value):
	if GameManager._getGameTimerActive():
		time += value
	
	secs = fmod(time, 60)
	mins = fmod(time, 60 * 60) / 60

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
	GameManager._setGameTimerActive(!GameManager._getGameTimerActive())
	GameManager._setGamePaused(!GameManager._getGamePause())
	pause.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_unhandled_input(false)
	get_tree().paused = true

func _onLevelAccomplish():
	GameManager._setGameOver(true)
	GameManager._setGameTimerActive(!GameManager._getGameTimerActive())
	resultPanel._showResult(mins, secs, self.name.right(5).to_int())
	
	if(resultPanel._newLevelUnlocked(requiredMedal)):
		GameManager._setOpenLevels(self.name.right(5).to_int() + 1)

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
