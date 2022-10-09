extends KinematicBody2D

onready var raycast := $RayCast2D
onready var animation := $AnimationPlayer

var gridSize: int = 16
var inputs = {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}
func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
			animatePlayer(inputs[dir])

func move(direction):
	var vectorPos = inputs[direction] * gridSize
	raycast.cast_to = vectorPos
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		position += vectorPos
	else:
		var collider = raycast.get_collider()
		if collider.is_in_group("Box"):
			if collider.move(direction):
				position += vectorPos

func animatePlayer(facing):
	match facing:
		Vector2.UP:
			animation.play("LookForward")
		Vector2.DOWN:
			animation.play("LookBackward")
		Vector2.LEFT:
			animation.play("LookLeft")
		Vector2.RIGHT:
			animation.play("LookRight")
	
