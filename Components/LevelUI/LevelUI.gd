extends CanvasLayer

signal puzzleIsDone
signal quizIsDone

onready var pausePanel := $PausePanel
onready var timer := $Timer
onready var hintPanel := $Quiz/HintPanel
onready var puzzleUI := $Puzzle
onready var quizUI := $Quiz
onready var requiredKeyPanel := $Puzzle/RequiredKeysPanel/Label

var time

func _ready():
	timer.connect("timesUp", self, "_setPuzzleTimer")
	quizUI.visible = false

func _on_PauseButton_pressed():
	pausePanel.visible = !pausePanel.visible
	get_tree().paused = true

func _setPuzzleTimer(value):
	time = value

func _getTimePast():
	return time

func _startTimer():
	timer._startTimer()

func _on_HintButton_pressed():
	hintPanel.visible = !hintPanel.visible

func _activatePuzzlePhase():
	puzzleUI.visible = true
	quizUI.visible = false

func _activateQuizPhase():
	quizUI.visible = true
	puzzleUI.visible = false
	_recordTimer()
	emit_signal("puzzleIsDone", _getTimePast())
	_startTimer()

func _recordTimer():
	timer._getTime()

func _endGame():
	quizUI.visible = false
	puzzleUI.visible = false

func _attachClueToPanel(value):
	hintPanel._setHint(value)

func _addNumberOfKeysToPanel(value):
	requiredKeyPanel.text = str(value)
