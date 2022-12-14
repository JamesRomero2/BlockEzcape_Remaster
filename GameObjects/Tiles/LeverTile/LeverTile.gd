extends Area2D

signal UnwalkableState

onready var sfx := $AudioStreamPlayer

var press: bool setget _setPress, _getPress
var time: int setget _setTime, _getTime

func _on_BridgeButton_body_entered(body):
	if body.name == "Player" || body.is_in_group("Box"):
		_setPress(true)
		emit_signal("UnwalkableState")
		sfx.play()

func _on_BridgeButton_body_exited(body):
	if body.name == "Player" || body.is_in_group("Box"):
		if get_overlapping_bodies().size() > 0:
			_setPress(true)
		else:
			_setPress(false)
	emit_signal("UnwalkableState")

func _on_Timer_timeout():
	_setPress(false)
	emit_signal("UnwalkableState")

func _setPress(value):
	press = value

func _getPress():
	return press

func _setTime(value):
	time = value

func _getTime():
	return time
