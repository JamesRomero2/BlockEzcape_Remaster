extends Node

onready var pause := $PausePanel
onready var animation := $AnimationPlayer
onready var camera := $Camera2D
onready var player := $GameObjects/Player
onready var wood := $GameObjects/Wood

var cutScene = load("res://Assets/Audio/Music/CutSceneBG.ogg")
var target = null
var woodShown = false

func _ready():
	GlobalMusic._changeMusic(cutScene)
	target = player

func _process(delta):
	camera.set_position(target.position)
	
func _startCutScene():
	GameManager._setGameOver(false)

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("escape") and !GameManager._getGameOver():
			_changeGameState()

func _changeGameState():
	GameManager._setGamePaused(!GameManager._getGamePause())
	pause.visible = !pause.visible

func _on_Area2D_body_entered(body):
	if body.name == "Player" and !woodShown:
		_playDialog('Dialog2')
		target = wood
		animation.play("Scene1_ShowPush")
		animation.stop(false)

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		woodShown = true
		target = player

func _on_Here_body_entered(body):
	if body.name == "Wood":
		animation.play("Scene1_ShowEnter")
		

func _playDialog1():
	_playDialog('Dialog1')
	animation.stop(false)

func _unPauseAnimation(timeline_name):
	animation.play()
	GameManager._setGamePaused(false)

func _playDialog(timelineTitle):
	if get_node_or_null('DialogNode') == null:
		GameManager._setGamePaused(true)
		var dialog = Dialogic.start(timelineTitle)
		dialog.connect('timeline_end', self, '_unPauseAnimation')
		add_child(dialog)
