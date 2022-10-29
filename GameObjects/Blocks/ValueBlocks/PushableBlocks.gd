extends KinematicBody2D

signal boxMoves(node)

onready var raycast := $RayCast2D
onready var digits := $DoubleDigits

export(int) var boxValue := 00

var journal: Array = Array()
var moving: bool = false
var gridSize: int = 16
var inputs := {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}

func _ready():
	_changeBoxValue(boxValue)

func _moveBoxToNextPos(direction):
	var vectorPos = inputs[direction] * gridSize
	raycast.cast_to = vectorPos
	raycast.force_raycast_update()
	var nextPos = position + vectorPos
	if !raycast.is_colliding():
		_moveToNextPos(nextPos)
		_objectStateJournal(vectorPos)
		emit_signal("boxMoves", self)
		return true
	return false

func _objectStateJournal(boxPosition):
	journal.append(boxPosition)

func _changeBoxValue(value):
	if value < 0:
		boxValue = 0
	elif value > 99:
		boxValue = 99
	else:
		boxValue = value
	_setBoxValue(boxValue)

func _moveToNextPos(pos):
	$Tween.interpolate_property (
		self, 
		"position",
		position, 
		pos, 
		0.2, 
		Tween.TRANS_QUART, 
		Tween.EASE_IN_OUT
	)
	$Tween.start()
	moving = true

func _setBoxValue(value):
	digits._setValue(value)
	digits._setDigit()

func _on_Tween_tween_completed(_object, _key):
	moving = false

func undoBoxPosition():
	if journal.empty(): return
	var vectorPos = journal.pop_back() * -1
	var nextPos = position + vectorPos
	_moveToNextPos(nextPos)

func undoBoxValue(value):
	boxValue = value
	_changeBoxValue(boxValue)
