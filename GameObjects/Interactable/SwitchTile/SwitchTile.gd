extends Area2D

signal switchStateSignal(state)

onready var sprite := $Sprite
onready var sfx := $SwitchSFX
onready var anim1: = $AnimationPlayer
onready var anim2: = $Anim2

var switchState: bool = true

func _on_Switch_body_entered(body):
	if body.name == "Player":
		switchState = !switchState
		_changeSprite()
		sfx.play()
		emit_signal("switchStateSignal", switchState)

func _changeSprite():
	if switchState:
		sprite.frame = 0
		anim1.play("NumberStateSwitchAnimation")
		anim2.play("NumberStateActivate")
	else:
		sprite.frame = 3
		anim1.play("ReaderStateSwitchAnimation")
		anim2.play("ReaderStateActivate")
