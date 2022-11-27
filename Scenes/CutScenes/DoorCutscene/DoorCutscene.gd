extends Node

onready var door := $CanvasLayer/Control/Door
onready var book := $CanvasLayer/Control/Book
onready var hex := $CanvasLayer/Control/Hexagram
onready var pause := $PausePanel

var worldMapScene = "res://Scenes/WorldMap/WorldMap.tscn"
var loading = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().current_scene = self
	get_tree().paused = false
	_changeBGToDoor()
	if get_node_or_null('DialogNode') == null:
		GameManager._setGamePaused(true)
		var dialog = Dialogic.start("DoorSceneDialog")
		dialog.connect('timeline_end', self, '_dialogEnd')
		dialog.connect('dialogic_signal', self, '_dialogic_signal')
		add_child(dialog)

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

func _dialogEnd(timeline_name):
	_loadWorldMap()

func _loadWorldMap():
	if loading: return
	GameManager._setOpenLevels(1)
	LoadingScreen.loadLevel("WorldMap")
	GameManager._setGamePaused(false)
	loading = true

func _dialogic_signal(signalName):
	match signalName:
		"changeToBook":
			_changeBGToBook()
		"changeToDoor":
			_changeBGToDoor()
		"changeToHex":
			_changeBGToHex()
	

func _changeBGToBook():
	door.visible = false
	hex.visible = false
	book.visible = true

func _changeBGToDoor():
	door.visible = true
	hex.visible = false
	book.visible = false

func _changeBGToHex():
	door.visible = false
	hex.visible = true
	book.visible = false
