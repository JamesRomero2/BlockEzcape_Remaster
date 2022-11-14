extends Position2D

export(String, "Up", "Down", "Left", "Right") var direction
export(float) var boulderPerSeconds := 1

onready var timer = $Timer

const boulder = preload("res://Scenes/Stages/BossStage/TheGolem/Power/Boulder.tscn")

var fire := false

func _ready():
	timer.wait_time = 1.0 / boulderPerSeconds

func _casting():
	if fire:
		var spawning = boulder.instance()
		
		match direction:
			"Up":
				spawning.flyingDirection = Vector2.UP
			"Down":
				spawning.flyingDirection = Vector2.DOWN
			"Left":
				spawning.flyingDirection = Vector2.LEFT
			"Right":
				spawning.flyingDirection = Vector2.RIGHT
		
		add_child(spawning)
		spawning.set_as_toplevel(true)
		spawning.global_position = global_position
		timer.start()

func _on_Timer_timeout():
	_casting()
