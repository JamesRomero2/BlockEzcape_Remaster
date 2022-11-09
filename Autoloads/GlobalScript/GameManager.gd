extends Node

onready var saveWorldFile = SaveWorldMap.worldData
onready var recordFile = SaveHighScore.highScoreData

var gamePaused := false setget _setGamePaused, _getGamePause
var gameOver := true setget _setGameOver, _getGameOver
var gameTimerActive := false setget _setGameTimerActive, _getGameTimerActive
var worldSelectorPosition: Vector2 = Vector2.ZERO setget _setWorldSelectorPosition, _getWorldSelectorPosition
var worldLevelOpen: Array = Array() setget _setOpenLevels, _getOpenLevels

func _setGamePaused(value):
	gamePaused = value

func _getGamePause():
	return gamePaused

func _setGameOver(value):
	gameOver = value

func _getGameOver():
	return gameOver

func _setWorldSelectorPosition(value):
	worldSelectorPosition = value
	saveWorldFile.worldSelectorPosition.x = worldSelectorPosition.x
	saveWorldFile.worldSelectorPosition.y = worldSelectorPosition.y
	SaveWorldMap._saveSettings()

func _getWorldSelectorPosition():
	worldSelectorPosition = Vector2(saveWorldFile.worldSelectorPosition.x, saveWorldFile.worldSelectorPosition.y)
	return worldSelectorPosition

func _setOpenLevels(value):
	if saveWorldFile.levelsOpen.has(value): return
	
	saveWorldFile.levelsOpen.push_back(value)
	SaveWorldMap._saveSettings()

func _getOpenLevels():
	worldLevelOpen = saveWorldFile.levelsOpen
	return worldLevelOpen

func _resetLevels():
	saveWorldFile.levelsOpen.clear()
	saveWorldFile.levelsOpen.push_back(0)
	SaveWorldMap._saveSettings()
	_resetRecords()

func _setGameTimerActive(value):
	gameTimerActive = value

func _getGameTimerActive():
	return gameTimerActive

func _getLevelRecord(levelNum):
	var record = Array()
	record.clear()
	record.append(recordFile[str(levelNum)].Time)
	record.append(recordFile[str(levelNum)].Ranking)
	return record

func _saveLevelRecord(levelNum, time, rank):
	recordFile[str(levelNum)].Time = time
	recordFile[str(levelNum)].Ranking = rank
	SaveHighScore._saveHighScore()

func _resetRecords():
	for levelRecord in recordFile:
		recordFile[str(levelRecord)].Time = "No Record Yet"
		recordFile[str(levelRecord)].Ranking = "No Record Yet"
	SaveHighScore._saveHighScore()

