extends Node

signal puzzlePhaseEnded
signal updateKey

onready var templeNode := $BoardSetup/InteractableObjects/Temple
onready var boardSetup := $BoardSetup
onready var quizPanel := $QuizPanel

var numberOfKeyInPuzzle: int = 1 setget _setNumberOfKeyInPuzzle, _getNumberOfKeyInPuzzle

var randQnAData = {}

func _ready():
	_connectSignals()
	_setNumberOfKeyInPuzzle(get_tree().get_nodes_in_group("Key").size())
	_generateDataFromJSON()

func _connectSignals():
	templeNode.connect("templeEntered", self, "_onPlayerEnteredTemple")
	
	for key in get_tree().get_nodes_in_group("Key"):
		key.connect("KeyCollected", self, "_onKeyCollected")

func _generateDataFromJSON():
	for i in _getNumberOfKeyInPuzzle():
		randQnAData[i + 1] = QuestionsLoader._getRandomQuestion(self.name, i + 1)
	
	quizPanel._getDataFromLevel(randQnAData, _getNumberOfKeyInPuzzle())

func _onPlayerEnteredTemple():
	boardSetup.visible = false
	quizPanel.visible = true
	emit_signal("puzzlePhaseEnded")
	boardSetup.queue_free()

func _onKeyCollected():
	_setNumberOfKeyInPuzzle(_getNumberOfKeyInPuzzle() - 1)
	if _getNumberOfKeyInPuzzle() == 0:
		templeNode._setDoorState(true)
		templeNode._setTexture()
	emit_signal("updateKey")

func _setNumberOfKeyInPuzzle(value):
	numberOfKeyInPuzzle = value

func _getNumberOfKeyInPuzzle():
	return numberOfKeyInPuzzle
