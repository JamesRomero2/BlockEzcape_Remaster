extends KinematicBody2D

signal boxMoves(node)

onready var raycast := $RayCast2D
onready var sprite := $OperationalSigns

export(String, "Plus", "Minus", "Times", "Divide", "Equals") var operation

var boxValue
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
	sprite._setSign(operation)
	
	match operation:
		"Plus":
			boxValue = "+"
		"Minus":
			boxValue = "-"
		"Times":
			boxValue = "x"
		"Divide":
			boxValue = "/"
		"Equals":
			boxValue = "="

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

func _on_Tween_tween_completed(object, key):
	moving = false

func undoBoxPosition():
	if journal.empty(): return
	var vectorPos = journal.pop_back() * -1
	var nextPos = position + vectorPos
	_moveToNextPos(nextPos)

func _objectStateJournal(boxPosition):
	journal.append(boxPosition)
