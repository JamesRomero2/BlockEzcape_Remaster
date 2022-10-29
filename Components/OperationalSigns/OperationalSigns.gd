extends Sprite

onready var animation := $AnimationPlayer

func _setSign(signValue: String):
	animation.play(signValue)
