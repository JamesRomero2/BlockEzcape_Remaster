extends Area2D

signal playerEnteredTemple

onready var spriteTexture: Sprite = $Sprite
onready var particle := $Particles2D

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

func _emitParticle():
	particle.emitting = true

func _on_Temple_area_entered(area):
	if area.name == "Player" and _getDoorState():
		emit_signal("playerEnteredTemple")
	else:
		print("Temple Not Activated")
