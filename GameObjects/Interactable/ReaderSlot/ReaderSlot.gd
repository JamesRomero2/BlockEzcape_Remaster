extends Area2D

var occupied := false

func _on_ReaderSlot_body_entered(body):
	if body.is_in_group("Box"):
		occupied = true
		print(body.boxValue)

func _on_ReaderSlot_body_exited(body):
	if body.is_in_group("Box"):
		occupied = false
