extends Node

onready var question = $Control/QuestionBG/Question
onready var choices = $Control/ChoicesBG/Choices
onready var cluePanel = $Control2/CluePanel
onready var clue = $Control2/CluePanel/VBoxContainer/Clue

var randQuestion = {}
var numberOfQuestions: int = 3
var currentPanel = 1

func _ready():
	_createQuestions()
	print(randQuestion)
	_displayQuestionsAndChoices()

func _createQuestions():
	for i in numberOfQuestions:
		randQuestion[i + 1] = QuestionsLoader._getRandomQuestion("Level1", str("Question", i + 1))

func _displayQuestionsAndChoices():
#	Display Question
	question.text = randQuestion[currentPanel]["Question"]
	
#	Display Choices
	for choice in choices.get_children():
		choice.text = randQuestion[currentPanel]["Choices"][str(choice.get_index() + 1)]
	
#	Display Clue
	clue.text = randQuestion[currentPanel]["Clue"]
	

func _on_NextButton_pressed():
	if currentPanel == numberOfQuestions:
		_levelEnd()
		return
	
	if currentPanel < numberOfQuestions:
		currentPanel += 1

	_displayQuestionsAndChoices()
	_showFinishButton()
	

func _on_BackButton_pressed():
	if currentPanel > 1:
		currentPanel -= 1

	_displayQuestionsAndChoices()
	_showFinishButton()

func _on_ClueButton_pressed():
	cluePanel.visible = !cluePanel.visible

func _showFinishButton():
	if currentPanel == numberOfQuestions:
		$Control/NextButton.text = "Finish"
	else:
		$Control/NextButton.text = "Next"

func _levelEnd():
	print("Run Method")
