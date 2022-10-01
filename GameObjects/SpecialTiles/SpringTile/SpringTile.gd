extends SpecialTile

func _onAreaPlayerEntered(area: Area2D):
	if area.name == "PlayerEffectArea":
		var playerObject = area.get_parent()
		playerObject.position = position + (playerObject._getPlayerVelocity() * 32)
