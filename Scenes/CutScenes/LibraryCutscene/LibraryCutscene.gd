extends Node

onready var camera := $Camera2D
onready var player := $Player
onready var enterParticle := $AttentionParticle
onready var closeParticle := $CloseParticle
onready var closeBook := $Close
onready var tween := $Tween
onready var animation := $AnimationPlayer
onready var pause := $PausePanel
onready var arrow := $Player/Arrow
onready var librarianPoint := $Pointers/Librarian
onready var bookPoint := $Pointers/Book
onready var task1 := $Player/Task1
onready var task2 := $Player/Task2
onready var interact := $Interact
onready var space := $Close/Space
onready var whirlpool := $Camera2D/Whirlpool

var target = null
var libraryMusic = load("res://Assets/Audio/Music/LibraryBG.ogg")
var near = false
var arrowTarget = null
var dialogPlaying := true

func _ready():
	GameManager._setGameOver(false)
	enterParticle.modulate.a = 0
	closeParticle.modulate.a = 0
	GlobalMusic._changeMusic(libraryMusic)
	GameManager._setGameOver(false)
	target = player
	arrowTarget = librarianPoint
	arrow.visible = false
	task1.visible = false
	task2.visible = false
	space.visible = false
	whirlpool.visible = false
	whirlpool.modulate.a = 0
	_playDialog()

func _process(delta):
	camera.set_position(target.position)
	var angle = rad2deg(atan2(player.position.x - arrowTarget.position.x, player.position.y - arrowTarget.position.y))
	arrow.rotation_degrees = angle * -1

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("escape") and !GameManager._getGameOver():
			_changeGameState()
		
		if event.is_action_pressed("space") and near:
			animation.play("bookOpenAnimation")
			near = false
		
		if event.is_action_pressed("space") and dialogPlaying:
			if interact.get_overlapping_bodies().size() > 0:
				if get_node_or_null('DialogNode') == null:
					GameManager._setGamePaused(true)
					dialogPlaying = false
					var dialog = Dialogic.start('/IntroDialog/LibrarianDialog')
					dialog.connect('timeline_end', self, '_unPauseAnimation')
					add_child(dialog)

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
	dialogPlaying = true
	if timeline_name == "Dialog3":
		task1.visible = true
		task2.visible = false
		arrow.visible = true
	if timeline_name == "/IntroDialog/LibrarianDialog":
		task1.visible = false
		task2.visible = true
		arrowTarget = bookPoint


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
		space.visible = true
		task2.visible = false
		arrow.visible = false

func _on_Close_body_exited(body):
	if body.name == "Player":
		closeParticle.modulate.a = 0
		enterParticle.modulate.a = 1
		target = player
		camera.zoom = Vector2(0.8, 0.8)
		GlobalMusic._unPauseMusic()
		near = false
		space.visible = false
		task2.visible = true
		arrow.visible = true

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
	target = player
	whirlpool.visible = true
	tween.interpolate_property(whirlpool, "modulate:a", 0, 1, 1.0,Tween.TRANS_QUINT,Tween.EASE_IN)
	tween.start()
	animation.play("transportToBlockEzcape")

func _nextScene():
	LoadingScreen.loadLevel("LabvrinthDoorScene")
