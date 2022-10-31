extends KinematicBody2D

signal objectStateChange(node)
signal playerPushed(node)

onready var raycast := $RayCast2D
onready var animation := $AnimationPlayer
onready var walkSFX := $SFX/WalkSFX
onready var undoWalkSFX := $SFX/UndoWalkSFX

var journal: Array = Array()
var moving: bool = false
var gridSize: int = 16
var inputs := {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}

func _process(delta):
	if GameManager._getGameOver() || GameManager._getGamePause():
		return

	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			if !moving:
				_playerMove(dir)

func _playerMove(direction):
	var vectorPos = inputs[direction] * gridSize
	_animatePlayer(vectorPos)
	raycast.cast_to = vectorPos
	raycast.force_raycast_update()
	var nextPos = position + vectorPos
	if !raycast.is_colliding():
		_moveToNextPos(nextPos)
		_objectStateJournal(vectorPos)
		emit_signal("objectStateChange", self)
	else:
		_pushBlocks(nextPos, direction, vectorPos)

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
	walkSFX.play()

func _pushBlocks(pos, dir, vPos):
	var collider = raycast.get_collider()
	if collider.is_in_group("Box") || collider.is_in_group("Symbols"):
		if collider._moveBoxToNextPos(dir):
			_moveToNextPos(pos)
			_objectStateJournal(vPos)
			emit_signal("playerPushed", self)

func undoMovement():
	if journal.empty(): return
	var vectorPos = journal.pop_back() * -1
	undoWalkSFX.play()
	var nextPos = position + vectorPos
	_moveToNextPos(nextPos)

func _objectStateJournal(playerMoves):
	journal.append(playerMoves)

func _undo():
	undoMovement()

func _animatePlayer(vector):
	if vector.x > 0:
		animation.play("LookRight")
	elif vector.x < 0:
		animation.play("LookLeft")
	if vector.y > 0:
		animation.play("LookBackward")
	elif vector.y < 0:
		animation.play("LookForward")
	
func _on_Tween_tween_completed(object, key):
	moving = false
	
