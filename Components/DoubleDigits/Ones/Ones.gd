extends Sprite

onready var animation := $AnimationPlayer

func _setOnesDigit(numValue: int, stringValue: String):
	self.frame = numValue
	animation.play(stringValue + "Anim")
