extends Area2D

var playerEntered: bool = true setget _setPlayerEntered, _getPlayerEntered

func _setPlayerEntered(value):
	playerEntered = value

func _getPlayerEntered():
	return playerEntered

func _on_StopTile_area_entered(area):
	if area.name == "Player" and _getPlayerEntered():
		area.get_parent().position = position
		area.get_parent()._setPlayerCanMove(true)
		area.get_parent()._on_TouchScreenButton_swipeDirection(Vector2.ZERO)
		_setPlayerEntered(false)

func _on_StopTile_area_exited(area):
	_setPlayerEntered(true)
