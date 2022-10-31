extends ParallaxBackground

const SPEED: int = 200

var direction = Vector2.LEFT

func _process(delta):
	scroll_offset += direction * SPEED * delta
