extends Node2D

export(int) var numberOfTraps = 2
export(int) var spawnWaitTime = 2

onready var timer := $Timer
onready var healTimer := $HealTimer
onready var traps := $Trap
onready var deathScreen := $Death/DeathScreen
onready var deathFog := $Death/ColorRect
onready var resetButton := $Death/DeathScreen/HBoxContainer/Reset
onready var quitButton := $Death/DeathScreen/HBoxContainer/Quit

func _ready():
	deathFog.material.set_shader_param("softness", 6)
	timer.wait_time = spawnWaitTime
	connectSignals()

func connectSignals():
	timer.connect("timeout", self, "trapSpawnerTimer")
	healTimer.connect("timeout", self, "_on_IncreaseHealth_timeout")
	resetButton.connect("buttonPressed", self, "_on_Reset_buttonPressed")
	quitButton.connect("buttonPressed", self, "_on_Quit_buttonPressed")

func _cast():
	var levelNum = self.owner.name.right(5).to_int()
	if GameManager._getGameOver(): return
	
	if levelNum > 0 and levelNum < 5:
		venomTrap()
	elif levelNum > 5 and levelNum < 10:
		boulderTrap()
	elif levelNum > 10 and levelNum < 15:
		swordTrap()
	elif levelNum > 15 and levelNum < 20:
		fireballTrap()

func trapSpawnerTimer():
	_cast()

func _onPlayerHurt():
	var currentValue = deathFog.material.get_shader_param("softness")
	if currentValue > 0:
		deathFog.material.set_shader_param("softness", currentValue - 1)
		healTimer.start()

	if (currentValue - 1) == 0:
		deathScreen.visible = true
		GameManager._setGameOver(true)
		GameManager._setGameTimerActive(!GameManager._getGameTimerActive())
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true

func _on_IncreaseHealth_timeout():
	var currentValue = deathFog.material.get_shader_param("softness")
	if (currentValue - 1) < 5 and !GameManager._getGameOver() and !GameManager._getGamePause():
		deathFog.material.set_shader_param("softness", currentValue + 1)
		healTimer.start()
	else:
		healTimer.stop()

func venomTrap():
	if !GameManager._getPlayerAnimating():
		randomize()
		var children = traps.get_children()
		for i in numberOfTraps:
			var trapObject = children[randi() % children.size()]
			if !trapObject.playing:
				trapObject._casting()
	timer.start()

func boulderTrap():
	var fires = Array()
	fires.clear()
	for boulder in traps.get_children():
		fires.push_back(boulder.fire)
	
	if fires.has(false):
		if !GameManager._getPlayerAnimating():
			randomize()
			var children = traps.get_children()
			for i in numberOfTraps:
				var trapObject = children[randi() % children.size()]
				trapObject.fire = true
				trapObject._casting()
		timer.start()
	else:
		timer.stop()

func swordTrap():
	if !GameManager._getPlayerAnimating():
		randomize()
		var children = traps.get_children()
		for i in numberOfTraps:
			var trapObject = children[randi() % children.size()]
			trapObject.activateCavalier()
	timer.start()

func fireballTrap():
	if !GameManager._getPlayerAnimating():
		randomize()
		var children = traps.get_children()
		for i in numberOfTraps:
			var trapObject = children[randi() % children.size()]
			trapObject._setTargetPost((trapObject.position - get_parent().get_node("Player").position) * -1)
			trapObject._casting()
	timer.start()


func _on_Reset_buttonPressed(buttonName):
	get_tree().reload_current_scene()

func _on_Quit_buttonPressed(buttonName):
	LoadingScreen.loadLevel("WorldMap")
