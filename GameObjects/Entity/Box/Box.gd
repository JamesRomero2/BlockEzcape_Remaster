extends KinematicBody2D

onready var raycast := $RayCast2D
#onready var animation := $AnimationPlayer

var gridSize: int = 16
var inputs = {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}

func move(direction):
	var vectorPos = inputs[direction] * gridSize
	raycast.cast_to = vectorPos
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		position += vectorPos
		return true
	return false

#func animatePlayer(facing):
#	match facing:
#		Vector2.UP:
#			print("ye")
#			animation.play("LookForward")
#		Vector2.DOWN:
#			animation.play("LookBackward")
#		Vector2.LEFT:
#			animation.play("LookLeft")
#		Vector2.RIGHT:
#			animation.play("LookRight")
	
