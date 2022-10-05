extends Node

signal quizIsDone

onready var scorePanel := $ScorePanel
onready var levelPanel := $LevelUI

var quizPanel

func _ready():
	quizPanel = get_node("Level").get_child(0)
	_connectSignals()
	_addHintToPanel()
	_addKeysToPanel()
	levelPanel._startTimer()
	scorePanel.visible = false
	scorePanel._setLevelNumber(quizPanel.name)

func _connectSignals():
	quizPanel.connect("keyUpdateUI", levelPanel, "_addNumberOfKeysToPanel")
	quizPanel.connect("QnAActivate", levelPanel, "_activateQuizPhase")
	quizPanel.connect("QuizDone", self, "_onGameIsDone")
	levelPanel.connect("puzzleIsDone", scorePanel, "_setPuzzleTime")
	self.connect("quizIsDone", scorePanel, "_setQuizTime")

func _activateQnA():
	quizPanel.visible = true
	quizPanel._startTimer()

func _addHintToPanel():
	levelPanel._attachClueToPanel(quizPanel._getHint())

func _addKeysToPanel():
	levelPanel._addNumberOfKeysToPanel(quizPanel._getNumberOfKeyInPuzzle())

func _onGameIsDone(score):
	scorePanel._setQuizScore(score)
	levelPanel._recordTimer()
	emit_signal("quizIsDone", levelPanel._getTimePast())
	scorePanel._resultSetter()
	scorePanel.visible = true
	levelPanel.visible = false
