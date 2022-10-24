extends KinematicBody2D

signal boxMoves(node)

onready var raycast := $RayCast2D
onready var sprite := $Sprite

export(int, "Add", "Minus", "Times", "Divide") var operation
var boxValue

var moving: bool = false
var gridSize: int = 16
var inputs := {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}

func _ready():
	sprite.frame = operation
	
	match operation:
		0:
			boxValue = "+"
		1:
			boxValue = "-"
		2:
			boxValue = "x"
		3:
			boxValue = "÷"

func _moveBoxToNextPos(direction):
	var vectorPos = inputs[direction] * gridSize
	raycast.cast_to = vectorPos
	raycast.force_raycast_update()
	var nextPos = position + vectorPos
	if !raycast.is_colliding():
		_moveToNextPos(nextPos)
		emit_signal("boxMoves", self)
#		print("box moce")
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
