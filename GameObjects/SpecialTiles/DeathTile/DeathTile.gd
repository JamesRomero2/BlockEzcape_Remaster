extends SpecialTile

func _onAreaPlayerEntered(area: Area2D):
	if area.name == "PlayerEffectArea":
		var playerObject = area.get_parent()
		playerObject.queue_free()

