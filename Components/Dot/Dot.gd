extends Sprite

func _ready():
	$Tween.interpolate_property(self, "frame", 10, 21, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
