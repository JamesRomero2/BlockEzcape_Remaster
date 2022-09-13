extends Area2D

signal PointCollected

var collected: bool = false

func _on_Point_body_entered(body: Node):
	if body.name == "Player" and !collected:
		emit_signal("PointCollected")
#		Add Method that will Increase the Player's Points
		queue_free()
