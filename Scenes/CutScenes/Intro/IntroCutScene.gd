extends Node

onready var pause := $PausePanel
onready var animation := $AnimationPlayer

func _startCutScene():
	GameManager._setGameOver(false)
	GameManager._setGameTimerActive(true)

func _unhandled_input(event):
	if event.is_pressed():
		if event.is_action_pressed("escape") and !GameManager._getGameOver():
			_changeGameState()

func _changeGameState():
	GameManager._setGamePaused(!GameManager._getGamePause())
	pause.visible = !pause.visible


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		animation.play("Scene1_ShowPush")


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		animation.play_backwards("Scene1_ShowPush")


func _on_Here_body_entered(body):
	if body.name == "Wood":
		animation.play("Scene1_ShowEnter")

func _playDialog1():
	animation.stop(false)
#	DIALOG 1
#	ARCHI: ALRIGHT ! CHORES ARE DONE, ITS TIME TO GO TO THE LIBRARY TO DO SOME HOMEWORK
#	ARCHI: FOR TODAYS HOME WORK IS... MATH (SAD FACE)
#	ARCHI: I HATE MATH, IM TO AFRAID TO SOLVE MATH INFRONT 
#	ARCHI: BUT STILL GOt TO DO WHAT YOU GOTTA DO
#	ARCHI: I WONDER IF THE LIBRARY HAS SOME BOOKS TO HELP ME WITH MATH
	animation.play()
	pass

func _playDialog2():
	animation.stop(false)
	#	DIALOG 2
#	ARCHI: THERES A WOOD STUCK IN MY WAY
#	ARCHI: BUT NO WORRIES IM SO STRONG
#	ARCHI: I CAN JUST PUSH THIS WOOD TO A SAFE AREA
	animation.play()
	pass
