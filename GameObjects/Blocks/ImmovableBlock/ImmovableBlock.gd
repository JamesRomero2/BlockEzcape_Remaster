extends StaticBody2D

export(String, "Forest", "Underground", "Dungeon", "Magical") var blockType

onready var sprite := $Sprite

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	match blockType:
		"Forest":
			sprite.frame = rng.randi_range(0, 7)
		"Underground":
			sprite.frame = rng.randi_range(8, 15)
		"Dungeon":
			sprite.frame = rng.randi_range(16, 23)
		"Magical":
			sprite.frame = rng.randi_range(24, 31)
