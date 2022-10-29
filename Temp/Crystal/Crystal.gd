extends Node2D

export(int, 0, 3) var scannerID

onready var digits := $DoubleDigits
onready var operations := $OperationalSigns
onready var crystalSprite := $Sprite

var reading: bool = false setget _setReading, _getReading


func _ready():
	_crystalHasValue(false, 0)

func _crystalHasValue(state, value):
	if state:
		_setReading(true)
		crystalSprite.visible = false
	
		if typeof(value) == TYPE_INT:
			operations.visible = false
			digits.visible = true
			if state:
				_setBoxValue(value)
				digits.visible = true
			else:
				_setBoxValue(0)
				digits.visible = false
		
		elif typeof(value) == TYPE_STRING:
			operations.visible = true
			digits.visible = false
			match value:
				"+":
					operations._setSign("Plus")
				"-":
					operations._setSign("Minus")
				"*":
					operations._setSign("Times")
				"/":
					operations._setSign("Divide")
				"=":
					operations._setSign("Equals")
			
	
	else:
		_setReading(false)
		crystalSprite.visible = true
		digits.visible = false
		operations.visible = false

func _setBoxValue(value):
	digits._setValue(value)
	digits._setDigit()

func _setReading(value):
	reading = value

func _getReading():
	return reading
