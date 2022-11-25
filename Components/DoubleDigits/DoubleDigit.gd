extends Node2D

export(int) var objectValue := 00
export(bool) var isWholeNumber := true

var valueText := {
	0: "Zero",
	1: "One",
	2: "Two",
	3: "Three",
	4: "Four",
	5: "Five",
	6: "Six",
	7: "Seven",
	8: "Eight",
	9: "Nine"
}

onready var ones := $Ones
onready var tens := $Tens

func _ready():
	setObjectsValue(objectValue)

func setObjectsValue(value):
	_setValue(value)
	_setDigit()

func _setDigit():
	if isWholeNumber:
		if _getWholeValue() < 10 and _getWholeValue() > 0:
			ones.visible = true
			tens.visible = false
		else:
			ones.visible = true
			tens.visible = true
	else:
		if _getOnesValue() == 0:
			ones.visible = false
			tens.visible = true
		else:
			ones.visible = true
			tens.visible = true
	
	ones._setOnesDigit(_getOnesValue(), valueText[_getOnesValue()])
	tens._setTensDigit(_getTensValue(), valueText[_getTensValue()])

func _setValue(value):
	objectValue = value

func _getOnesValue():
	return objectValue % 10

func _getTensValue():
	return (objectValue / 10) % 10

func _getWholeValue():
	return objectValue
