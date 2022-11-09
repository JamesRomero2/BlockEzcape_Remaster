extends Node

onready var camera := $Camera2D
onready var player := $Player
onready var enterParticle := $AttentionParticle
onready var closeParticle := $CloseParticle
onready var closeBook := $Close
onready var tween := $Tween
onready var animation := $AnimationPlayer
onready var pause := $PausePanel

var target = null
var libraryMusic = load("res://Assets/Audio/Music/LibraryBG.ogg")
var near = false

func _ready():
	GameManager._setGameOver(false)
	enterParticle.modulate.a = 0
	closeParticle.modulate.a = 0
	GlobalMusic._changeMusic(libraryMusic)
	GameManager._setGameOver(false)
	target = player
	_playDialog()

func _process(delta):
	camera.set_position(target.position)

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("escape") and !GameManager._getGameOver():
			_changeGameState()
		
		if event.is_action_pressed("space") and near:
			animation.play("bookOpenAnimation")
			near = false

func _changeGameState():
	GameManager._setGamePaused(!GameManager._getGamePause())
	pause.visible = !pause.visible

func _playDialog():
	if get_node_or_null('DialogNode') == null:
		GameManager._setGamePaused(true)
		var dialog = Dialogic.start('Dialog3')
		dialog.connect('timeline_end', self, '_unPauseAnimation')
		add_child(dialog)

func _unPauseAnimation(timeline_name):
	GameManager._setGamePaused(false)

func _on_Area2D2_body_entered(body):
	if body.name == "Player":
		enterParticle.modulate.a = 1

func _on_Area2D2_body_exited(body):
	if body.name == "Player":
		enterParticle.modulate.a = 0

func _on_Close_body_entered(body):
	if body.name == "Player":
		enterParticle.modulate.a = 0
		closeParticle.modulate.a = 1
		tween.interpolate_property(camera, "zoom",
		Vector2(0.8, 0.8), Vector2(0.5, 0.5), .5,
		tween.TRANS_LINEAR, tween.EASE_IN_OUT)
		tween.start()
		target = closeBook
		GlobalMusic._pauseMusic()
		near = true

func _on_Close_body_exited(body):
	if body.name == "Player":
		closeParticle.modulate.a = 0
		enterParticle.modulate.a = 1
		target = player
		camera.zoom = Vector2(0.8, 0.8)
		GlobalMusic._unPauseMusic()
		near = false

func _changeBookSprite():
	$Close/Sprite.texture = load("res://Scenes/CutScenes/LibraryCutscene/Texture/BookOpen.png")

func _animationPause():
	if get_node_or_null('DialogNode') == null:
		GameManager._setGamePaused(true)
		var dialog = Dialogic.start("Dialog4")
		dialog.connect('timeline_end', self, '_animationUnpause')
		add_child(dialog)
	animation.stop(false)

func _animationUnpause(timeline_name):
	animation.play()

func _continueAnim():
	LoadingScreen.loadLevel("LabvrinthDoorScene")
