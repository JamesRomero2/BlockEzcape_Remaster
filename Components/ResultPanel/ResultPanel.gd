extends CanvasLayer

onready var levelNumUnlocked = $Container/NewLevelUnlocked/LevelNumberUnlocked
onready var levelNumLocked = $Container/LevelRequirements/VBoxContainer/RichTextLabel2

var medal: int = 0
var animating: bool = true

var newRecord: bool = false
var newLevel: bool = false

var playedLevelNumber: int 
var playedLevelInterpretedTime: String
var playedLevelTimeMinutes: float
var playedLevelTimeSeconds: float
var playedLevelRequiredRank: int
var playedLevelAttainedRank: String
var lastLevel: bool = false

func _showResult(mins, secs, levelNum, requiredMedalInLevel):
	playedLevelTimeMinutes = mins
	playedLevelTimeSeconds = secs
	playedLevelNumber = levelNum
	playedLevelRequiredRank = requiredMedalInLevel
	
	playedLevelInterpretedTime = "%02d : %02d" % [mins, secs]
	self.visible = !self.visible
	
	setTextOnLabels()
	_setMedalRanking()
	checkForNewLevel()
	checkForNewHighScore()


	if (playedLevelNumber + 1) == 21:
		$AnimationPlayer.play("ResultsAnimationForEndLevel")
	else:
		$AnimationPlayer.play("ResultsAnimation")

func _input(event):
	if event.is_pressed() and !animating:
		if event.is_action_pressed("space"):
			LoadingScreen.loadLevel("WorldMap")

func _setMedalRanking():
	for medal in $Container/Awards.get_children():
		medal.visible = false

	var minutes = int(playedLevelTimeMinutes)
	var seconds = int(playedLevelTimeSeconds)

	if minutes == 0:
		medal = 4
		$Container/Label6.text = "S"
		$Container/Awards/Platinum.visible = true
		playedLevelAttainedRank = "S"
	elif minutes == 1:
		medal = 3
		$Container/Label6.text = "A"
		$Container/Awards/Gold.visible = true
		playedLevelAttainedRank = "A"
	elif minutes == 2:
		medal = 2
		$Container/Label6.text = "B"
		playedLevelAttainedRank = "B"
		$Container/Awards/Silver.visible = true
	elif minutes == 3:
		medal = 1
		$Container/Label6.text = "C"
		$Container/Awards/Bronze.visible = true
		playedLevelAttainedRank = "C"
	else:
		medal = 0
		$Container/Label6.text = "D"
		$Container/Awards/Copper.visible = true
		playedLevelAttainedRank = "D"

func checkForNewLevel():
	if medal >= playedLevelRequiredRank:
		newLevel = true
	else:
		newLevel = false

func checkForNewHighScore():
	if GameManager._getLevelRecord(playedLevelNumber)[1] == 0.0:
		newRecord = true
	else:
		if playedLevelTimeMinutes < GameManager._getLevelRecord(playedLevelNumber)[1]:
			newRecord = true
		else:
			newRecord = false

func _playDialog():
	if newLevel:
		if !GameManager._getOpenLevels().has(playedLevelNumber + 1):
			$AnimationPlayer.play("NewLevel")
			GameManager._setOpenLevels(playedLevelNumber + 1)
		else:
			if newRecord:
				$AnimationPlayer.play("NewRecord")
				saveRecordToSaveFile()
	else:
		$AnimationPlayer.play("LevelLocked")
	animating = false

func playHighScoreAnimation():
	if newRecord:
		$AnimationPlayer.play("NewRecord")
		saveRecordToSaveFile()

func setTextOnLabels():
	var rank: String
	match playedLevelRequiredRank:
		0:
			rank = "D"
		1:
			rank = "C"
		2:
			rank = "B"
		3:
			rank = "A"
		4:
			rank = "S"
	$Container/Label4.text = playedLevelInterpretedTime
	if playedLevelNumber < 10: 
		levelNumUnlocked.text = "Level 0" + str(playedLevelNumber + 1)
		levelNumLocked.set_bbcode("[center]Sorry Little One\nGet [b]Rank " + rank + "[/b] to Open [b]Level 0" + str(playedLevelNumber + 1) + " [/b][/center]")
	else:
		levelNumUnlocked.text = "Level " + str(playedLevelNumber + 1)
		levelNumLocked.set_bbcode("[center]Sorry Little One\nGet [b]Rank " + rank + "[/b] to Open [b]Level " + str(playedLevelNumber + 1) + " [/b][/center]")

func saveRecordToSaveFile():
	GameManager._saveLevelRecord(playedLevelNumber, playedLevelInterpretedTime, playedLevelAttainedRank, playedLevelTimeMinutes, playedLevelTimeSeconds)

func playLastScene():
	if newRecord:
		saveRecordToSaveFile()
	LoadingScreen.loadLevel("Credits")

func openFinal():
	$Container/ColorRect2/Label3.visible = true

func openEnd():
	$Container/ColorRect2/Label3.visible = false
	$Container/ColorRect2/Label4.visible = true
