extends Node

export(Color) var colorTheme

onready var themeColor := $CanvasLayer/Color

func _ready():
	_changeTheme()
#	GlobalMusic._changeMusic()
	pass

func _unhandled_input(event):
	if event.is_pressed():
		if !event.is_action_pressed("undo"):
			print("Add<pce")
		if event.is_action_pressed("mute"):
			GlobalMusic._muteMusic()
		if event.is_action_pressed("unmute"):
			GlobalMusic._playMusic()

func _changeTheme():
	themeColor.color = colorTheme
