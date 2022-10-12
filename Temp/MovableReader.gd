extends Node2D

onready var raycast := $RayCast2D

var gridSize: int = 16
var inputs := {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}
var canMove := false setget _setCanMove, _getCanMove

func move(direction):
	if !_getCanMove(): return
	var vectorPos = inputs[direction] * gridSize
	raycast.cast_to = vectorPos
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		position += vectorPos
		return true
	return false

func _on_Area2D_body_entered(body):
	print(body)

func _on_Area2D_body_exited(body):
	print(body)

func _setCanMove(value):
	canMove = value

func _getCanMove():
	return canMove
