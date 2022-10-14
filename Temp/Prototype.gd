extends Node

export(Color) var colorTheme

onready var themeColor := $CanvasLayer/Color

var unwalkables := Array()
var mainMenuScene = load("res://Scenes/MainMenu/MainMenu.tscn")
var answer : bool = false

func _ready():
	_changeTheme()
	_connectAllBridge()
#	GlobalMusic._changeMusic()
	pass

func _unhandled_input(event):
	if event.is_pressed():
#		if !event.is_action_pressed("undo"):
#			print("Add<pce")
		if event.is_action_pressed("mute"):
			GlobalMusic._muteMusic()
		if event.is_action_pressed("unmute"):
			GlobalMusic._playMusic()
		if event.is_action_pressed("space"):
			_getAllBridgeState()
			print(_getAllBridgeState())
		if event.is_action_pressed("escape"):
			 _openScenes(mainMenuScene)

func _changeTheme():
	themeColor.color = colorTheme

func _on_BridgeButton_UnwalkableState():
	for unWalkable in get_tree().get_nodes_in_group("Unwalkable"):
		if _getAllBridgeState().has(true):
			unWalkable._setDisableToTrue()
		else:
			unWalkable._setDisableToFalse()

func _connectAllBridge():
	for bridge in get_tree().get_nodes_in_group("Bridge"):
		bridge.connect("UnwalkableState", self, "_on_BridgeButton_UnwalkableState")

func _getAllBridgeState():
	var bridges := Array()
	bridges.clear()
	for bridgeButton in get_tree().get_nodes_in_group("Bridge"):
		bridges.append(bridgeButton._getPress())
	return bridges

func _getAllUnwalkable():
	for unWalkable in get_tree().get_nodes_in_group("Unwalkable"):
		unwalkables.append(unWalkable)

func _openScenes(value):
	var ERR = get_tree().change_scene_to(value)
	
	if ERR != OK:
		print("Something is wrong")
		get_tree().quit()

func _on_ReaderSlot_boxValue(valueNumber):
	if valueNumber == null:
		$MathPanel/Control/Panel/HBoxContainer/Control/TextureRect.visible = true
		$MathPanel/Control/Panel/HBoxContainer/Control/Label5.text = ""
	else:
		$MathPanel/Control/Panel/HBoxContainer/Control/TextureRect.visible = false
		$MathPanel/Control/Panel/HBoxContainer/Control/Label5.text = str(valueNumber)
		if valueNumber == 5:
			$Temple.answer = true
		else:
			$Temple.answer = false
