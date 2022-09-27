extends CanvasLayer

signal puzzleIsDone

onready var pausePanel := $PausePanel
onready var timer := $Timer
onready var hintPanel := $Quiz/HintPanel
onready var puzzleUI := $Puzzle
onready var quizUI := $Quiz

func _ready():
	timer.connect("timesUp", self, "_setPuzzleTimer")
	quizUI.visible = false

func _on_PauseButton_pressed():
	pausePanel.visible = !pausePanel.visible
	get_tree().paused = true

func _setPuzzleTimer(value):
	pass

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

func _endGame():
	quizUI.visible = false
	puzzleUI.visible = false
