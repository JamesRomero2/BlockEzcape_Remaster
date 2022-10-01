extends SpecialTile

onready var sprite = $Sprite

export(String, "Up", "Right", "Down", "Left") var direction
var vectorDirection = {
	"Up": Vector2.UP,
	"Right": Vector2.RIGHT,
	"Down": Vector2.DOWN,
	"Left": Vector2.LEFT,
}

func _ready():
	match direction:
		"Up":
			sprite.rotation_degrees = 0
		"Right":
			sprite.rotation_degrees = 90
		"Down":
			sprite.rotation_degrees = 180
		"Left":
			sprite.rotation_degrees = 270

func _onAreaPlayerEntered(area: Area2D):
	if area.name == "PlayerEffectArea":
		var playerObject = area.get_parent()
		playerObject.position = position
		playerObject._setPlayerCanMove(true)
		playerObject._onPlayerSwipeDirection(vectorDirection[direction])
