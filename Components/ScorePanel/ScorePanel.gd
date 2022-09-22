extends CanvasLayer

onready var level = $NinePatchRect/Level
onready var quizScoreCount = $NinePatchRect/QuizScore
onready var puzzleTimeResult = $NinePatchRect/PuzzleTimer/Time
onready var quizTimeResult = $NinePatchRect/QuizTimer/Time

func _resultSetter(levelNumber: String, correctAnswer: String, puzzleTime: String, quizTime: String):
	level.text = levelNumber
	quizScoreCount.text = correctAnswer
	puzzleTimeResult.text = puzzleTime
	quizTimeResult.text = quizTime
