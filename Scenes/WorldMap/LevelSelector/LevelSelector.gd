extends KinematicBody2D

onready var raycast := $RayCast2D
onready var animation := $AnimationPlayer
onready var walkSFX := $SFX/WalkSFX
var gridSize: int = 16
var inputs = {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}
var level:PackedScene setget _setLevel, _getLevel

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
		if event.is_action_pressed("space"):
			var ERR = get_tree().change_scene_to(_getLevel())
	
			if ERR != OK:
				print("Something is wrong")
				get_tree().quit()

func move(direction):
	var vectorPos = inputs[direction] * gridSize
	walkSFX.play()
	raycast.cast_to = vectorPos
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		position += vectorPos

func _setLevel(value):
	level = value

func _getLevel():
	return level
