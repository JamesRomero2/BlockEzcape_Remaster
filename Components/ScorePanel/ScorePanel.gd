extends CanvasLayer

onready var level = $NinePatchRect/Level
onready var quizScoreCount = $NinePatchRect/QuizScore
onready var puzzleTimeResult = $NinePatchRect/PuzzleTimer/Time
onready var quizTimeResult = $NinePatchRect/QuizTimer/Time

var levelNumber: String = "Level 00" setget _setLevelNumber, _getLevelNumber
var quizScore: String = "0 / 0" setget _setQuizScore, _getQuizScore
var puzzleTime: String = "00mins : 00secs" setget _setPuzzleTime, _getPuzzleTime
var quizTime: String = "00mins : 00secs" setget _setQuizTime, _getQuizTime

func _resultSetter():
	level.text = _getLevelNumber()
	quizScoreCount.text = _getQuizScore()
	puzzleTimeResult.text = _getPuzzleTime()
	quizTimeResult.text = _getQuizTime()

func _setLevelNumber(value: String):
	levelNumber = value

func _getLevelNumber():
	return levelNumber

func _setQuizScore(value: String):
	quizScore = value

func _getQuizScore():
	return quizScore

func _setPuzzleTime(value: String):
	puzzleTime = value

func _getPuzzleTime():
	return puzzleTime

func _setQuizTime(value: String):
	quizTime = value

func _getQuizTime():
	return quizTime
