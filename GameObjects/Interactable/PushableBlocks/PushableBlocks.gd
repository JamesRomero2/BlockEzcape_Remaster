extends KinematicBody2D

onready var raycast := $RayCast2D
onready var digits := $DoubleDigits

export(int) var boxValue := 00

var gridSize: int = 16
var inputs := {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}

func _ready():
	_changeBoxValue(boxValue)

func move(direction):
	var vectorPos = inputs[direction] * gridSize
	raycast.cast_to = vectorPos
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		position += vectorPos
		return true
	return false

func _changeBoxValue(value):
	if value < 0:
		boxValue = 0
	elif value > 99:
		boxValue = 99
	else:
		boxValue = value
	_setBoxValue(boxValue)

func _setBoxValue(value):
	digits._setValue(value)
	digits._setDigit()
