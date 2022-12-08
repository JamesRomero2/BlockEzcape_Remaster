extends Node2D

export(int) var numberOfTraps = 2
export(int) var spawnWaitTime = 2

onready var timer := $Timer
onready var traps := $Trap

func _ready():
	timer.wait_time = spawnWaitTime
	connectSignals()

func connectSignals():
	timer.connect("timeout", self, "trapSpawnerTimer")

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



