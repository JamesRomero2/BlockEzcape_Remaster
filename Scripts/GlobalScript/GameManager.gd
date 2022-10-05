extends Node

var levelScene : PackedScene = preload("res://Scenes/Levels/Level 2/Level2.tscn") setget _setWhereLevelScene, _getWhereLevelScene

func _setWhereLevelScene(value: PackedScene):
	levelScene = value

func _getWhereLevelScene():
	return levelScene
