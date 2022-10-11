extends CanvasLayer

onready var parallax = $ParallaxBackground

const SPEED: int = 300

var direction = Vector2.LEFT

func _process(delta):
	parallax.scroll_offset += direction * SPEED * delta
