extends KinematicBody2D

onready var raycast := $RayCast2D
onready var animation := $AnimationPlayer
onready var walkSFX := $SFX/WalkSFX
onready var undoWalkSFX := $SFX/UndoWalkSFX

var gridSize: int = 16
var inputs = {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}
var playerPositions := Array()

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
	if event.is_action_pressed("undo"):
		undo()

func move(direction):
	var vectorPos = inputs[direction] * gridSize
	walkSFX.play()
	animatePlayer(vectorPos)
	playerPositions.append(vectorPos)
	raycast.cast_to = vectorPos
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		position += vectorPos
	else:
		var collider = raycast.get_collider()
		if collider.is_in_group("Box"):
			if collider.move(direction):
				position += vectorPos

func undo():
	if playerPositions.empty(): return
	var vectorPos = playerPositions.pop_back() * -1
	undoWalkSFX.play()
	animatePlayer(vectorPos)
	raycast.cast_to = vectorPos
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		position += vectorPos
		

func animatePlayer(vector):
	if vector.x > 0:
		animation.play("LookRight")
	elif vector.x < 0:
		animation.play("LookLeft")
	if vector.y > 0:
		animation.play("LookBackward")
	elif vector.y < 0:
		animation.play("LookForward")
	
