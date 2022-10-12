extends Area2D

onready var numberSprite := $Number
onready var operationSprite := $Operation
onready var animation := $AnimationPlayer

export(int, "Add", "Minus", "Times", "Divide") var operation
export(int, "1", "2", "3") var num

var collected := false

func _ready():
	_setTextureSprites()

func _setTextureSprites():
	operationSprite.frame = operation
	numberSprite.frame = num

func calculate(value):
	match operation:
		0:
			return value + (num + 1)
		1:
			return value - (num + 1)
		2:
			return value * (num + 1)
		3:
			return value / (num + 1)

func _on_OperationalTile_body_entered(body):
	if body.is_in_group("Box") and !collected:
		body.boxValue = calculate(body.boxValue)
		body._setSpriteBasedOnValue()
		collected = true
		animation.play("Collected")
		

