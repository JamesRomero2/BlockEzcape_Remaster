extends Node2D

var digitValue
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

func _setDigit():
	ones._setOnesDigit(_getOnesValue(), valueText[_getOnesValue()])
	tens._setTensDigit(_getTensValue(), valueText[_getTensValue()])

func _setValue(value):
	digitValue = value

func _getOnesValue():
	return digitValue % 10

func _getTensValue():
	return (digitValue / 10) % 10

