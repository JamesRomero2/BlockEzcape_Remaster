extends Area2D

signal playerEnteredTemple

onready var spriteTexture: Sprite = $Sprite

var doorState: bool = false setget _setDoorState, _getDoorState
var doorTexture = {
	false: load("res://Assets/Textures/TempleTile2.png"),
	true: load("res://Assets/Textures/TempleTile1.png")
}
func _ready():
	_setTexture()

func _setDoorState(value):
	doorState = value

func _getDoorState():
	return doorState 

func _setTexture():
	spriteTexture.texture = doorTexture[_getDoorState()]

func _on_Temple_body_entered(body):
	if body.name == "Player":
		emit_signal("playerEnteredTemple")
