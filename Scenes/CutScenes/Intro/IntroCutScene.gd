extends Node

onready var pause := $PausePanel
onready var animation := $AnimationPlayer
onready var camera := $Camera2D
onready var player := $GameObjects/Player
onready var wood := $GameObjects/Wood
onready var arrow := $GameObjects/Player/Arrow
onready var libraryPoint = $Pointer/LibraryPosition
onready var safeAreaPoint = $Pointer/SafeAreaPosition
onready var gotoLibr := $GameObjects/Player/GotoLibrary
onready var gotoSafe := $GameObjects/Player/GotoSafeArea
onready var placeHere := $GameObjects/Interact3/Here
onready var tween := $Tween

var cutScene = load("res://Assets/Audio/Music/CutSceneBG.ogg")
var target = null
var woodShown = false
var arrowTarget = null

func _ready():
	get_tree().current_scene = self
	get_tree().paused = false
	GameManager._setGameOver(false)
	GameManager._setGamePaused(true)
	GlobalMusic._changeMusic(cutScene)
	target = player
	arrow.visible = false
	gotoLibr.visible = false
	gotoSafe.visible = false
	arrowTarget = libraryPoint
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	camera.set_position(target.position)
	var angle = rad2deg(atan2(player.position.x - arrowTarget.position.x, player.position.y - arrowTarget.position.y))
	arrow.rotation_degrees = angle * -1
	
func _startCutScene():
	GameManager._setGamePaused(false)

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("escape") and !GameManager._getGameOver():
			_changeGameState()

func _changeGameState():
	GameManager._setGamePaused(!GameManager._getGamePause())
	pause.visible = !pause.visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_unhandled_input(false)
	get_tree().paused = true

func _on_Area2D_body_entered(body):
	if body.name == "Player" and !woodShown:
		_playDialog('Dialog2')
		gotoLibr.visible = false
		target = wood
		animation.play("Scene1_ShowPush")
		animation.stop(false)
		arrowTarget = safeAreaPoint
		gotoSafe.visible = true

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		woodShown = true
		target = player

func _on_Here_body_entered(body):
	if body.name == "Wood":
		animation.play("Scene1_ShowEnter")
		arrowTarget = libraryPoint
		gotoLibr.visible = true
		gotoSafe.visible = false
		tween.interpolate_property(placeHere, "modulate:a", 1, 0, .5, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()

func _playDialog1():
	_playDialog('Dialog1')
	animation.stop(false)

func _unPauseAnimation(timeline_name):
	animation.play()
	GameManager._setGamePaused(false)
	if timeline_name == "Dialog1":
		arrow.visible = true
		gotoLibr.visible = true

func _playDialog(timelineTitle):
	if get_node_or_null('DialogNode') == null:
		GameManager._setGamePaused(true)
		var dialog = Dialogic.start(timelineTitle)
		dialog.connect('timeline_end', self, '_unPauseAnimation')
		add_child(dialog)


func _on_Tween_tween_completed(object, key):
	if object.name == "Here":
		placeHere.visible = false
	
	pass # Replace with function body.
