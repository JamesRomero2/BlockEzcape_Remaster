extends AnimatedSprite

var target := Vector2.ZERO
export(float) var boulderPerSeconds := 1

onready var timer = $Timer

const fireball = preload("res://Scenes/Stages/BossStage/TheEye/Power/Fireball.tscn")

func _casting():
	var spawning = fireball.instance()
	spawning.flyingDirection = _getTargetPost().normalized()
	add_child(spawning)
	spawning.set_as_toplevel(true)
	spawning.global_position = global_position

func _setTargetPost(value):
	target = value

func _getTargetPost():
	return target
