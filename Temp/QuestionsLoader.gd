extends Node

var filePath = "res://Assets/JSONData/Questions.json"
var fileData = {}
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	loadQuestions()
	if fileData.empty():
		print("Missing Questions. Please Contact Support")
		return

func loadQuestions():
	var file = File.new()
	
	if not file.file_exists(filePath):
		print("Missing Questions. Please Contact Support")
		return
	
	file.open(filePath, File.READ)

	var data = parse_json(file.get_as_text())
	fileData = data

	file.close()

func _getRandomQuestion(levelNumber, questionNumber):
	var randomNum = rng.randi_range(1, 3)
	var randomQuestions = fileData[str(levelNumber)][questionNumber]["Type" + str(randomNum)]
	return randomQuestions
