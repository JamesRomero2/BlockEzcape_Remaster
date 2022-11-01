extends Node

onready var door := $CanvasLayer/Control/Door
onready var book := $CanvasLayer/Control/Book
onready var hex := $CanvasLayer/Control/Hexagram
onready var pause := $PausePanel

var worldMapScene = "res://Scenes/WorldMap/WorldMap.tscn"

func _ready():
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

func _dialogEnd(timeline_name):
	SceneTransition._changeScene(worldMapScene)
	GameManager._setGamePaused(false)

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
