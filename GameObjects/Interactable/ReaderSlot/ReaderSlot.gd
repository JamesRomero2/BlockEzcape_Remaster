extends Area2D

signal boxValue(valueNumber)

onready var sfx := $AudioStreamPlayer
var occupied := false

func _on_ReaderSlot_body_entered(body):
	if body.is_in_group("Box"):
		occupied = true
		emit_signal("boxValue", body.boxValue)
		sfx.play()

func _on_ReaderSlot_body_exited(body):
	if body.is_in_group("Box"):
		emit_signal("boxValue", null)
		occupied = false
