extends Node2D

export(int, 0, 3) var scannerID
export(bool) var isCrystalWholeNumber := true

onready var digits := $DoubleDigits
onready var crystalSprite := $Sprite

var reading: bool = false setget _setReading, _getReading

func _ready():
	_crystalHasValue(false, 0)
	$Sprite.frame = scannerID
	digits.isWholeNumber = isCrystalWholeNumber

func _crystalHasValue(state, value):
	if state:
		_setReading(true)
		crystalSprite.visible = false
		digits.visible = true
		if state:
			_setBoxValue(value)
			digits.visible = true
		else:
			_setBoxValue(0)
			digits.visible = false
	else:
		_setReading(false)
		crystalSprite.visible = true
		digits.visible = false

func _setBoxValue(value):
	digits._setValue(value)
	digits._setDigit()

func _setReading(value):
	reading = value

func _getReading():
	return reading
