extends CanvasLayer

signal quizIsDone

onready var question = $QuestionBG/Question
onready var buttonChoices = $ButtonContainer

var randQnA = {} setget _setRandQnA, _getRandQnA
var numberOfQuestions: int = 1 setget _setNumberOfQuestions, _getNumberOfQuestions
var currentPanel = 1
var correctAnswer = 0

func _ready():
	_connectSignals()

func _connectSignals():
	for i in buttonChoices.get_children():
		i.connect("pressed", self, "_onPlayerSelects", [i])

func _displayQuestionsAndChoices():
#	Display Question
	question.text = _getRandQnA()[currentPanel]["Question"]

#	Display Choices
	for choice in buttonChoices.get_children():
		var choiceLabel = choice.get_child(0).get_child(0).get_child(1)
		choiceLabel.text = _getRandQnA()[currentPanel]["Choices"][str(choice.get_index() + 1)]

func _on_NextButton_pressed():
	var score = "%s / %s" % [str(correctAnswer), str(numberOfQuestions)]
	if currentPanel == numberOfQuestions:
		emit_signal("quizIsDone", score)
		print("out of questions")
		return

	if currentPanel < numberOfQuestions:
		currentPanel += 1

	_displayQuestionsAndChoices()

func _currentPanelHint():
	return _getRandQnA()[currentPanel]["Clue"]

#SIGNAL RECEIVER FUNCTIONS
func _onPlayerSelects(button):
	var playersAnswer = button.get_child(0).get_child(0).get_child(1).text
	var rightAnswer = _getRandQnA()[currentPanel]["Answer"]
	if playersAnswer == rightAnswer:
		correctAnswer += 1
		print("Right")
	else:
		print("Wrong")

	_on_NextButton_pressed()

#SETTER AND GETTER FUNCTION
func _setRandQnA(value):
	randQnA = value

func _getRandQnA():
	return randQnA

func _setNumberOfQuestions(value):
	numberOfQuestions = value

func _getNumberOfQuestions():
	return numberOfQuestions
