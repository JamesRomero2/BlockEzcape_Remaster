extends Node

onready var camera := $Camera2D
onready var player := $GameArea/Player
onready var enterParticle := $AttentionParticle
onready var closeParticle := $CloseParticle
onready var closeBook := $Close
onready var tween := $Tween
onready var animation := $AnimationPlayer
onready var pause := $PausePanel
onready var arrow :=  $GameArea/Player/Arrow
onready var librarianPoint := $Pointers/Librarian
onready var bookPoint := $Pointers/Book
onready var task := $GameArea/Player/Task1
onready var taskLabel := $GameArea/Player/Task1/Label
onready var interact := $Interact
onready var space := $Close/Space
onready var whirlpool := $Camera2D/Whirlpool

var target = null
var libraryMusic = load("res://Assets/Audio/Music/LibraryBG.ogg")
var near = false
var arrowTarget = null
var dialogPlaying := true
var task1 = "Approach Librarian"
var task2 = "Find Vase"
var task3 = "Bring Vase to the Librarian"
var task4 = "Locate Room with a Book"
var taskState = -1
var playerEnteredVase = false

func _ready():
	get_tree().current_scene = self
	get_tree().paused = false
	GameManager._setGameOver(false)
	enterParticle.modulate.a = 0
	closeParticle.modulate.a = 0
	GlobalMusic._changeMusic(libraryMusic)
	GameManager._setGameOver(false)
	target = player
	arrowTarget = librarianPoint
	arrow.visible = false
	task.visible = false
	space.visible = false
	whirlpool.visible = false
	whirlpool.modulate.a = 0
	_playDialog()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	camera.set_position(target.position)
	var angle = rad2deg(atan2(player.position.x - arrowTarget.position.x, player.position.y - arrowTarget.position.y))
	arrow.rotation_degrees = angle * -1

func _unhandled_input(event):
	var dialog
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
						if taskState == -1:
							dialog = Dialogic.start('/IntroDialog/LibrarianDialog')
						if taskState == 0:
							dialog = Dialogic.start('/IntroDialog/LibrarianVaseDialog')
						if taskState == 1:
							dialog = Dialogic.start('/IntroDialog/LibrarianVaseTaskDone')
						dialog.connect('timeline_end', self, '_unPauseAnimation')
						add_child(dialog)

func _changeGameState():
	GameManager._setGamePaused(!GameManager._getGamePause())
	pause.visible = !pause.visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_unhandled_input(false)
	get_tree().paused = true

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
		task.visible = true
		arrow.visible = true
	if timeline_name == "/IntroDialog/LibrarianDialog":
		taskState = 0
		arrowTarget = $GameArea/Box
		taskLabel.text = task2
	if timeline_name == "/IntroDialog/LibrarianVaseTaskDone":
		arrowTarget = bookPoint
		taskLabel.text = task4

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
		task.visible = false
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
		task.visible = true
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

func _on_LeverTile_body_entered(body):
	if body.name == "Box":
		taskState = 1
		$GameObjects/WallCollisions/Door.set_deferred("disabled", true)
		$GameWorld/TileMap6.visible = false
		$GameArea/Room.visible = false

func _on_Area2D_body_entered(body):
	if body.name == "Player" and !playerEnteredVase:
		playerEnteredVase = true
		arrowTarget = $GameArea/LeverTile
		taskLabel.text = task3
