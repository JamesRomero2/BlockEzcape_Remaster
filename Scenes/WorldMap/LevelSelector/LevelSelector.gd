extends KinematicBody2D

signal enteringLevel

onready var raycast := $RayCast2D
onready var animation := $AnimationPlayer
onready var walkSFX := $SFX/WalkSFX

var level setget _setLevel, _getLevel
var levelState: bool = false setget _setLevelState, _getLevelState
var levelInfo := {
	"LevelPath": "",
	"LevelNumber": -1,
	"LevelTitle": ""
}

var moving: bool = false
var gridSize: int = 32
var inputs = {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT
}

func _process(delta):
	if GameManager._getGamePause():
		return
	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			if !moving:
				_move(dir)

func _unhandled_input(event):
	if GameManager._getGamePause():
		return
	if event.is_action_pressed("space") and !moving:
		if levelInfo["LevelNumber"] < 0: return
		
		if levelInfo["LevelNumber"] == 0:
			emit_signal("enteringLevel", levelInfo)
		
		LoadingScreen.loadLevel(levelInfo["LevelPath"])
		GameManager._setWorldSelectorPosition(position)

func _move(direction):
	var vectorPos = inputs[direction] * gridSize
	raycast.cast_to = vectorPos / self.scale
	raycast.force_raycast_update()
	var nextPos = position + vectorPos
	if !raycast.is_colliding():
		_moveToNextPos(nextPos)

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

func _on_Tween_tween_completed(_object, _key):
	moving = false

func _setLevel(value):
	level = value

func _getLevel():
	return level

func _setLevelState(value):
	levelState = value

func _getLevelState():
	return levelState

func _setLevelInfo(levelpath, levelNumber, levelTitle):
	levelInfo["LevelPath"] = levelpath
	levelInfo["LevelNumber"] = levelNumber
	levelInfo["LevelTitle"] = levelTitle
