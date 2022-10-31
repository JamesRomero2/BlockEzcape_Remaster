extends Node

onready var camera := $Camera2D
onready var player := $Player


var target = null
var libraryMusic = load("res://Assets/Audio/Music/LibraryBG.ogg")

func _ready():
	GlobalMusic._changeMusic(libraryMusic)
	GameManager._setGameOver(false)
	target = player
	_playDialog("Dialog3")

func _process(delta):
	camera.set_position(target.position)

func _playDialog(timelineTitle):
	if get_node_or_null('DialogNode') == null:
		GameManager._setGamePaused(true)
		var dialog = Dialogic.start(timelineTitle)
		dialog.connect('timeline_end', self, '_unPauseAnimation')
		add_child(dialog)

func _unPauseAnimation(timeline_name):
	GameManager._setGamePaused(false)
