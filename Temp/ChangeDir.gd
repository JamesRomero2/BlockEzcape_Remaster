extends Area2D

var playerInside = false

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.position = position
		body._setPlayerCanMove(true)
		body._on_TouchScreenButton_swipeDirection(Vector2.UP)
