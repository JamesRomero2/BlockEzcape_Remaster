extends Area2D

onready var digits := $DoubleDigits
onready var animation := $AnimationPlayer

export(String) var targetLevel setget , _getTargetLevel
export(String) var levelTitle := ""
export(int) var levelNumber := 00
export(bool) var levelOpen: bool = false

var onTop: bool = false

func _ready():
	_setLevelNum(levelNumber)
	_setLevelState(levelOpen)

func _on_LevelContainer_body_entered(body):
	if !levelOpen: return
	if body.name == "LevelSelector": 
		if get_overlapping_bodies().size() > 0:
			body._setLevelInfo(targetLevel, levelNumber, levelTitle)
	else:
		body._setLevelInfo("", -1, "")

func _on_LevelContainer_body_exited(body):
	if !levelOpen: return
	if body.name == "LevelSelector":
		if get_overlapping_bodies().size() > 0:
			body._setLevelInfo(targetLevel, levelNumber, levelTitle)
		else:
			body._setLevelInfo("", -1, "")

func _setLevelNum(value):
	digits._setValue(value)
	digits._setDigit()

func _getTargetLevel():
	return targetLevel

func _setLevelState(value: bool):
	if value:
		digits.visible = true
		animation.play("LevelContainerOpenAnim")
		self.modulate.a = 1.0
	else:
		digits.visible = false
		animation.play("LevelContainerCloseAnim")
		self.modulate.a = .5




