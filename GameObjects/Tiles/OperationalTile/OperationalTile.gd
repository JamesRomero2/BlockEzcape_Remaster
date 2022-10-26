extends Area2D

signal operationalTileState(node)

onready var operationSprite := $Operation
onready var animation := $AnimationPlayer
onready var sfx := $AudioStreamPlayer
onready var digits := $DoubleDigits
onready var collisions := $CollisionShape2D

export(int, "Add", "Minus", "Times", "Divide") var operation
export(int, 0, 99) var operationalValue := 00

var collected := false

func _ready():
	_setTextureSprites()

func _setTextureSprites():
	operationSprite.frame = operation
	_changeBoxValue(operationalValue)

func calculate(value):
	if typeof(value) == TYPE_INT:
		match operation:
			0:
				return value + operationalValue
			1:
				return value - operationalValue
			2:
				return value * operationalValue
			3:
				return value / operationalValue

func _changeBoxValue(value):
	if value < 0:
		operationalValue = 0
	elif value > 99:
		operationalValue = 99
	else:
		operationalValue = value
	_setBoxValue(operationalValue)

func _setBoxValue(value):
	digits._setValue(value)
	digits._setDigit()

func _on_OperationalTile_body_entered(body):
	if body.is_in_group("Box") and !collected:
		if typeof(body.boxValue) == TYPE_INT:
			body._changeBoxValue(calculate(body.boxValue))
			collected = true
			collisions.set_deferred("disabled", true)
			sfx.play()
			animation.play("Collected")
			emit_signal("operationalTileState", self)

func _undoOperationalTile():
	collisions.set_deferred("disabled", false)
	animation.play_backwards("Collected")
	yield(self, "body_exited")
	collected = false

func _on_OperationalTile_body_exited(body):
	if !get_overlapping_bodies().size() > 0:
#		collisions.set_deferred("disabled", false)
		yield()
		collected = false
