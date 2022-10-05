extends CanvasLayer

signal quizDone
signal passClue(clue)

onready var question = $QuestionBG/Question
onready var buttonChoices = $ButtonContainer

var randQnA = {} setget _setRandQnA, _getRandQnA
var numberOfQuestions: int = 1 setget _setNumberOfQuestions, _getNumberOfQuestions
var correctAnswer: int = 0 setget _setCorrectAnswer, _getCorrectAnswer
var clue: String setget _setClue, _getClue

var currentPanel = 1

func _ready():
	_connectSignals()

func _connectSignals():
	for i in buttonChoices.get_children():
		i.connect("pressed", self, "_onPlayerSelects", [i])

func _getDataFromLevel(data, numberOfQuestions):
	_setRandQnA(data)
	_setNumberOfQuestions(numberOfQuestions)
	_displayQuestionsAndChoices()

func _displayQuestionsAndChoices():
	question.text = _getRandQnA()[currentPanel]["Question"]
	_setClue(_getRandQnA()[currentPanel]["Clue"])
	emit_signal("passClue", _getRandQnA()[currentPanel]["Clue"])

	for choice in buttonChoices.get_children():
		var choiceLabel = choice.get_child(0).get_child(0).get_child(1)
		choiceLabel.text = _getRandQnA()[currentPanel]["Choices"][str(choice.get_index() + 1)]

func _on_NextButton_pressed():
	var score = "%s / %s" % [str(_getCorrectAnswer()), str(numberOfQuestions)]
	if currentPanel == numberOfQuestions:
		emit_signal("quizDone", score)
		self.visible = false
		queue_free()
		return

	if currentPanel < numberOfQuestions:
		currentPanel += 1

	_displayQuestionsAndChoices()

func _onPlayerSelects(button):
	var playersAnswer = button.get_child(0).get_child(0).get_child(1).text
	var rightAnswer = _getRandQnA()[currentPanel]["Answer"]
	if playersAnswer == rightAnswer:
		_setCorrectAnswer(_getCorrectAnswer() + 1)
		print("Right")
	else:
		print("Wrong")

	_on_NextButton_pressed()

func _setRandQnA(value):
	randQnA = value

func _getRandQnA():
	return randQnA

func _setNumberOfQuestions(value):
	numberOfQuestions = value

func _getNumberOfQuestions():
	return numberOfQuestions

func _setCorrectAnswer(value):
	correctAnswer = value

func _getCorrectAnswer():
	return correctAnswer

func _setClue(value):
	clue = value

func _getClue():
	return clue
