extends Control

onready var faceCard := $FaceCard
onready var cardSprite := $FaceCard/Sprite
onready var answer := $Answer

export(int, 0, 3) var cardID

func _ready():
	cardSprite.frame = cardID

func _setAnswer(value):
	answer.text = str(value)
	faceCard.visible = false
	answer.visible = true

func _revertFaceCard(value):
	answer.text = str(value)
	faceCard.visible = true
	answer.visible = false

func _checkID(id, answer, pushed):
	if id == cardID:
		if pushed:
			_setAnswer(answer)
		else:
			_revertFaceCard(answer)
