extends Area2D

func _on_SpringTile_area_entered(area):
	if area.name == "Player":
		var playerObject = area.get_parent()
		playerObject.position = position + (playerObject._getPlayerVelocity() * 32)
		
