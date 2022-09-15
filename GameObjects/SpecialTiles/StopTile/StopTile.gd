extends Area2D

var playerEntered: bool = true setget _setPlayerEntered, _getPlayerEntered

func _setPlayerEntered(value):
	playerEntered = value

func _getPlayerEntered():
	return playerEntered

func _on_StopTile_area_entered(area):
	if area.name == "Player" and _getPlayerEntered():
		var playerObject = area.get_parent()
		playerObject.position = position
		playerObject._setPlayerCanMove(true)
		playerObject._on_TouchScreenButton_swipeDirection(Vector2.ZERO)
		_setPlayerEntered(false)

func _on_StopTile_area_exited(area):
	_setPlayerEntered(true)
