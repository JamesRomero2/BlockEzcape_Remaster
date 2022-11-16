extends StaticBody2D

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$Sprite.frame = rng.randi_range(0, 7)
