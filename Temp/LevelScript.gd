extends Node

signal keyUpdateUI
signal QnAActivate
signal QuizDone

onready var templeNode := $BoardSetup/InteractableObjects/Temple
onready var board := $BoardSetup
onready var quizPanel := $QuizPanel

var randQnAData = {}

var numberOfKeyInPuzzle: int = 1 setget _setNumberOfKeyInPuzzle, _getNumberOfKeyInPuzzle
var canEnterTemple: bool = false setget _setCanEnterTemple, _getCanEnterTemple

func _ready():
	_connectAllSignals()
	_setNumberOfKeyInPuzzle(get_tree().get_nodes_in_group("Key").size())
	_generateQnAData()

func _connectAllSignals():
#	Temple Signal
	templeNode.connect("TempleEntered", self, "_onPlayerEnteredTemple")
	quizPanel.connect("quizIsDone", self, "_onGameDone")
	
#	Key Signal
	for key in get_tree().get_nodes_in_group("Key"):
		key.connect("KeyCollected", self, "_onKeyCollected")

func _activatePuzzle():
#	RESET/STOP TIMER
	board.visible = true
	quizPanel.visible = false
#	START TIMER

func _activateQuiz():
#	RESET/STOP TIMER
	board.visible = false
	quizPanel.visible = true
#	START TIMER

func _generateQnAData():
	for i in _getNumberOfKeyInPuzzle():
		randQnAData[i + 1] = QuestionsLoader._getRandomQuestion(self.name, i + 1)
	
	_sendDataToQuiz()

func _sendDataToQuiz():
	quizPanel._setRandQnA(randQnAData)
	quizPanel._setNumberOfQuestions(_getNumberOfKeyInPuzzle())
	quizPanel._displayQuestionsAndChoices()

func _getHint():
	return quizPanel._currentPanelHint()

#SIGNAL RECEIVER FUNCTIONS
func _onPlayerEnteredTemple():
#	IF TEMPLE IS CLOSED: OPEN PANEL SAYING TEMPLE IS CLOSED
#	IF TEMPLE IS ACTIVATE: PROCEED QUIZ PANEL
	if _getCanEnterTemple():
		print("Temple Activated")
		_activateQuiz()
		emit_signal("QnAActivate")
		board.queue_free()
	else:
		print("Temple Not Activated")

func _onKeyCollected():
	_setNumberOfKeyInPuzzle(_getNumberOfKeyInPuzzle() - 1)
	if _getNumberOfKeyInPuzzle() == 0:
		templeNode._setDoorState(true)
		templeNode._setTexture()
		_setCanEnterTemple(true)
	
	emit_signal("keyUpdateUI", _getNumberOfKeyInPuzzle())

func _onGameDone(value):
	emit_signal("QuizDone", value)
	quizPanel.visible = false
	quizPanel.queue_free()

#SETTER AND GETTER FUNCTION
func _setNumberOfKeyInPuzzle(value):
	numberOfKeyInPuzzle = value

func _getNumberOfKeyInPuzzle():
	return numberOfKeyInPuzzle

func _setCanEnterTemple(value):
	canEnterTemple = value

func _getCanEnterTemple():
	return canEnterTemple
