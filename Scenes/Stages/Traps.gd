extends Node2D

export(int) var numberOfTraps = 2
export(int) var spawnWaitTime = 2

onready var timer := $Timer
onready var healTimer := $HealTimer
onready var traps := $Trap
onready var deathScreen := $Death/DeathScreen
onready var venomFog := $Death/ColorRect

func _ready():
	venomFog.material.set_shader_param("softness", 6)
	timer.wait_time = spawnWaitTime
	timer.connect("timeout", self, "trapSpawnerTimer")
	healTimer.connect("timeout", self, "_on_IncreaseHealth_timeout")

func _cast():
	if GameManager._getGameOver(): return
	randomize()
	var children = traps.get_children()
	for i in numberOfTraps:
		var trapObject = children[randi() % children.size()]
		if !trapObject.playing:
			trapObject._casting()
	timer.start()

func trapSpawnerTimer():
	_cast()

func _onPlayerHurt():
	var currentValue = venomFog.material.get_shader_param("softness")
	if currentValue > 0:
		venomFog.material.set_shader_param("softness", currentValue - 1)
		healTimer.start()

	if (currentValue - 1) == 0:
		deathScreen.visible = true
		GameManager._setGameOver(true)
		GameManager._setGameTimerActive(!GameManager._getGameTimerActive())
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_IncreaseHealth_timeout():
	var currentValue = venomFog.material.get_shader_param("softness")
	if (currentValue - 1) < 5 and !GameManager._getGameOver() and !GameManager._getGamePause():
		venomFog.material.set_shader_param("softness", currentValue + 1)
		healTimer.start()
	else:
		healTimer.stop()
