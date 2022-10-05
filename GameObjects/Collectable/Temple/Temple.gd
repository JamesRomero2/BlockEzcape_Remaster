extends Collectable

signal templeEntered

onready var spriteTexture: Sprite = $Sprite
onready var animation: AnimationPlayer = $AnimationPlayer

var doorState: bool = false setget _setDoorState, _getDoorState
var doorTexture = {
	false: load("res://Assets/Textures/TempleTile2.png"),
	true: load("res://Assets/Textures/TempleTile1.png")
}
func _ready():
	_setTexture()

func _setTexture():
	spriteTexture.texture = doorTexture[_getDoorState()]
	
	if _getDoorState():
		animation.play("OpenTemple")

func _onAreaEntered(area: Area2D):
	if area.name == "PlayerEffectArea" and _getDoorState():
		emit_signal("templeEntered")
		print("Temple Activated")
	else:
		print("Temple Not Activated")

func _setDoorState(value):
	doorState = value

func _getDoorState():
	return doorState 
