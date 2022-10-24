extends Node

var gamePaused := false setget _setGamePaused, _getGamePause
var gameOver := true setget _setGameOver, _getGameOver

func _setGamePaused(value):
	gamePaused = value

func _getGamePause():
	return gamePaused

func _setGameOver(value):
	gameOver = value

func _getGameOver():
	return gameOver
