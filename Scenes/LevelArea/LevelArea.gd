extends Node

onready var level = $Level
onready var levelUI = $LevelUI
onready var resultPanel = $ScorePanel

func _ready():
	level.add_child(GameManager._getWhereLevelScene().instance())
	level = level.get_child(0)
	_connectSignals()
	_onLevelStart()

func _connectSignals():
	level.connect("puzzlePhaseEnded", self, "_onPuzzlePhaseDone")
	level.quizPanel.connect("quizDone", self, "_onQuizPhaseDone")
	level.quizPanel.connect("passClue", levelUI, "_onSetHintToPanel")
	level.connect("updateKey", self, "_onUpdateUIKey")

func _onLevelStart():
	levelUI.timer._startTimer()
	_connectData()

func _onPuzzlePhaseDone():
	levelUI._activateQuizUI()
	levelUI.timer._getTime()
	levelUI.timer._startTimer()
	resultPanel._setPuzzleTime(levelUI._getTimeValue())

func _onQuizPhaseDone(value):
	levelUI.timer._getTime()
	resultPanel._setQuizTime(levelUI._getTimeValue())
	resultPanel._setQuizScore(value)
	resultPanel._setLevelNumber(level.name)
	
	resultPanel._resultSetter()
	levelUI.visible = false
	level.queue_free()
	resultPanel.visible = true

func _connectData():
	levelUI._onSetHintToPanel(level.quizPanel._getClue())
	levelUI._setRequiredKeysPanel(level._getNumberOfKeyInPuzzle())

func _onUpdateUIKey():
	levelUI._setRequiredKeysPanel(level._getNumberOfKeyInPuzzle())
