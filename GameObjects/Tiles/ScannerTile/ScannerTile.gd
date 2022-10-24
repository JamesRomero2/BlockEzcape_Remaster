extends Area2D

signal boxValue(valueNumber, scannerId)

export(int, 0, 3) var scannerID

onready var sfx := $AudioStreamPlayer
onready var sprite := $Sprite

var result := false setget _setResult, _getResult
var occupied := false

func _ready():
	sprite.frame = scannerID

func _on_ReaderSlot_body_entered(body):
	if body.is_in_group("Box"):
		occupied = true
		emit_signal("boxValue", body.boxValue, scannerID, self)
		sfx.play()

func _on_ReaderSlot_body_exited(body):
	if body.is_in_group("Box"):
		emit_signal("boxValue", null, scannerID, self)
		_setResult(false)
		occupied = false

func _setResult(value):
	result = value

func _getResult():
	return result 
