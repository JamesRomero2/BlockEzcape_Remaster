extends Area2D

signal levelAccomplish

onready var spriteTexture: Sprite = $Sprite
onready var animation: AnimationPlayer = $AnimationPlayer

var doorState: bool = false setget _setDoorState, _getDoorState
var doorTexture = {
	false: load("res://GameObjects/Tiles/TempleTile/Texture/TempleClose.png"),
	true: load("res://GameObjects/Tiles/TempleTile/Texture/TempleOpen.png")
}
var answer : bool = false setget _setAnswer, _getAnswer

func _ready():
	_setTexture()

func _setTexture():
	spriteTexture.texture = doorTexture[_getDoorState()]
	
	if _getDoorState():
		animation.play("OpenTemple")
	else:
		animation.play("CloseTemple")

func _on_Temple_body_entered(body):
	if body.name == "Player" and _getDoorState():
		if _getAnswer():
			emit_signal("levelAccomplish")

func _setDoorState(value):
	doorState = value
	_setTexture()

func _getDoorState():
	return doorState 

func _setAnswer(value):
	answer = value

func _getAnswer():
	return answer 
