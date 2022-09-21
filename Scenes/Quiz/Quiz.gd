extends CanvasLayer

onready var question = $QuestionBG/Question
onready var hintPanel = $HintPanel
onready var buttonChoices = $ButtonContainer
onready var timer := $Timer

var randQuestion = {}
var numberOfQuestions: int = 3
var currentPanel = 1
var correctAnswer = 0
var canAnswer = true

func _ready():
	_connectButtons()
	_createQuestions()
	_displayQuestionsAndChoices()

func _createQuestions():
	for i in numberOfQuestions:
		randQuestion[i + 1] = QuestionsLoader._getRandomQuestion("Level1", str("Question", i + 1))

func _displayQuestionsAndChoices():
#	Display Question
	question.text = randQuestion[currentPanel]["Question"]
	
#	Display Choices
	for choice in buttonChoices.get_children():
		var choiceLabel = choice.get_child(0).get_child(0).get_child(1)
		choiceLabel.text = randQuestion[currentPanel]["Choices"][str(choice.get_index() + 1)]
	
#	Display Clue
	hintPanel._setHint(randQuestion[currentPanel]["Clue"])

func _on_NextButton_pressed():
	if currentPanel == numberOfQuestions:
		_levelEnd()
		return
	
	if currentPanel < numberOfQuestions:
		currentPanel += 1
	
	_displayQuestionsAndChoices()

func _on_ClueButton_pressed():
	hintPanel.visible = !hintPanel.visible

func _levelEnd():
	print("Run Method")
	print("Score : %s / %s" % [str(correctAnswer), str(numberOfQuestions)])

func _onPlayerSelects(button):
	var playersAnswer = button.get_child(0).get_child(0).get_child(1).text
	var rightAnswer = randQuestion[currentPanel]["Answer"]
	if playersAnswer == rightAnswer:
		correctAnswer += 1
		print("Right")
	else:
		print("Wrong")
	
	_on_NextButton_pressed()

func _connectButtons():
	for i in buttonChoices.get_children():
		i.connect("pressed", self, "_onPlayerSelects", [i])

func _startTimer():
	timer._startTimer()
