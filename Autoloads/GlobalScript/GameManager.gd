extends Node

onready var saveWorldFile = SaveWorldMap.worldData

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
	worldLevelOpen = value
	saveWorldFile.levelsOpen = worldLevelOpen
	SaveWorldMap._saveSettings()

func _getOpenLevels():
	worldLevelOpen = saveWorldFile.levelsOpen
	return worldLevelOpen

func _setGameTimerActive(value):
	gameTimerActive = value

func _getGameTimerActive():
	return gameTimerActive
