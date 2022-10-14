extends Sprite

onready var animation := $AnimationPlayer

func _setTensDigit(numValue: int, stringValue: String):
	self.frame = numValue
	animation.play("Tens" + stringValue + "Anim")
