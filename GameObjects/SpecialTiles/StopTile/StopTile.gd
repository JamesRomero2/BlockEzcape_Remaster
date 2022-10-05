extends SpecialTile

var playerEntered: bool = true setget _setPlayerEntered, _getPlayerEntered

func _setPlayerEntered(value):
	playerEntered = value

func _getPlayerEntered():
	return playerEntered

func _onAreaPlayerEntered(area: Area2D):
	if area.name == "PlayerEffectArea" and _getPlayerEntered():
		var playerObject = area.get_parent()
		playerObject.position = position
		playerObject._setPlayerCanMove(true)
		playerObject._onPlayerSwipeDirection(Vector2.ZERO)
		_setPlayerEntered(false)

func _on_StopTile_area_exited(area: Area2D):
	_setPlayerEntered(true)
