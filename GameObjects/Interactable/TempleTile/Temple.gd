extends Area2D

signal templeEntered

onready var spriteTexture: Sprite = $Sprite
onready var animation: AnimationPlayer = $AnimationPlayer

var doorState: bool = false setget _setDoorState, _getDoorState
var doorTexture = {
	false: load("res://Assets/Textures/TempleTile2.png"),
	true: load("res://Assets/Textures/TempleTile1.png")
}
var answer : bool = false

func _ready():
	_setTexture()

func _setTexture():
	spriteTexture.texture = doorTexture[_getDoorState()]
	
	if _getDoorState():
		animation.play("OpenTemple")

func _on_Temple_body_entered(body):
	if body.name == "Player":
		if answer:
			print("VICTORY")
		else:
			print("DEFEAT")
		

func _setDoorState(value):
	doorState = value

func _getDoorState():
	return doorState 

