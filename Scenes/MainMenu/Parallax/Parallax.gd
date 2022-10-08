extends CanvasLayer

export(int) var speed: int = 300
export(int) var rotation_speed: float = 0.3

onready var parallax = $ParallaxBackground

var direction = Vector2.LEFT

func _process(delta):
	parallax.scroll_offset += direction * speed * delta
