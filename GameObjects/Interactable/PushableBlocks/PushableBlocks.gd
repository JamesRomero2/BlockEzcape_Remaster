extends KinematicBody2D

onready var raycast := $RayCast2D
onready var animation := $AnimationPlayer
export(int) var boxValue := 0

var boxValueText := {
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

var gridSize: int = 16
var inputs := {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}

func _ready():
	_setSpriteBasedOnValue()

func move(direction):
	var vectorPos = inputs[direction] * gridSize
	raycast.cast_to = vectorPos
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		position += vectorPos
		return true
	return false

func _setSpriteBasedOnValue():
	animation.play(str(boxValueText[boxValue]) + "Animation")

