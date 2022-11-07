extends Node

export(PackedScene) var set1
export(PackedScene) var set2
export(PackedScene) var set3

onready var pause := $PausePanel
onready var resultPanel := $ResultPanel
onready var animation := $AnimationPlayer

var set: int = 0
var puzzleSets = Array()
var time = 0
var secs
var mins

func _ready():
	puzzleSets = [set1, set2, set3]
	_setPuzzle()

func _connectSignals():
	pass

func _process(delta):
	_gameTimer(delta)

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("escape") and !GameManager._getGameOver():
			_changeGameState()

func _changeGameState():
	GameManager._setGameTimerActive(!GameManager._getGameTimerActive())
	GameManager._setGamePaused(!GameManager._getGamePause())
	pause.visible = !pause.visible
	set_process_unhandled_input(false)
	get_tree().paused = !get_tree().paused

func _gameTimer(value):
	if GameManager._getGameTimerActive():
		time += value
	
	secs = fmod(time, 60)
	mins = fmod(time, 60 * 60) / 60

func _setPuzzle():
	print("Setting Puzzle...")
	
	if puzzleSets.has(""):
		print("Please Set all Puzzle")
		
	animation.play("Transition")
	yield($AnimationPlayer, "animation_finished")
	
	if $GameObjects.get_child_count() > 0:
		for node in $GameObjects.get_children():
			node.queue_free()
	
	var instanceSet = puzzleSets[set].instance()
	instanceSet.connect("setDone", self, "_setComplete")
	$GameObjects.call_deferred("add_child", instanceSet)
		
	$AnimationPlayer.play_backwards("Transition")

	GameManager._setGamePaused(false)
	GameManager._setGameTimerActive(true)

func _changeSet():
	if set >= 0 and set <= 2:
		GameManager._setGamePaused(true)
		GameManager._setGameTimerActive(false)
		print("Changing Set...")
		set += 1

func _setComplete():
	_changeSet()
	_setPuzzle()
