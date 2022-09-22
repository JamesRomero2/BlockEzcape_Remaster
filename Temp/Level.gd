extends Node

onready var templeNode := $BoardSetup/InteractableObjects/Temple
onready var board := $BoardSetup
onready var quizPanel := $QuizPanel
onready var scorePanel := $ScorePanel

var numberOfKeyInPuzzle: int = 0 setget _setNumberOfKeyInPuzzle, _getNumberOfKeyInPuzzle
var canEnterTemple: bool = false setget _setCanEnterTemple, _getCanEnterTemple

func _ready():
	_connectAllKeys()
	_connectTempleSignal()
	_connectQuizSignal()
	_setNumberOfKeyInPuzzle(get_tree().get_nodes_in_group("Key").size())
	quizPanel.visible = false
	scorePanel.visible = false

func _connectAllKeys():
	for key in get_tree().get_nodes_in_group("Key"):
		key.connect("KeyCollected", self, "_onKeyCollected")

func _connectTempleSignal():
	templeNode.connect("playerEnteredTemple", self, "_onPlayerEnteredTemple")

func _connectQuizSignal():
	quizPanel.connect("quizIsDone", self, "_showResult")

func _onKeyCollected():
	_setNumberOfKeyInPuzzle(_getNumberOfKeyInPuzzle() - 1)
	if _getNumberOfKeyInPuzzle() == 0:
		templeNode._setDoorState(true)
		templeNode._setTexture()
		templeNode._emitParticle()
		_setCanEnterTemple(true)

func _onPlayerEnteredTemple():
	_disableBoard()
	_activateQnA()

func _activateQnA():
	quizPanel.visible = true
	quizPanel._startTimer()

func _disableBoard():
	board.visible = false

func _showResult(score, timeSpent):
	scorePanel.visible = true
	scorePanel._resultSetter("Level 1", score, "2:00", timeSpent)

#SETTER AND GETTER FUNCTION
func _setNumberOfKeyInPuzzle(value):
	numberOfKeyInPuzzle = value

func _getNumberOfKeyInPuzzle():
	return numberOfKeyInPuzzle

func _setCanEnterTemple(value):
	canEnterTemple = value

func _getCanEnterTemple():
	return canEnterTemple
