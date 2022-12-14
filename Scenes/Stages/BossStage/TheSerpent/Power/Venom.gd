extends Node

signal playerAffected

onready var animation := $AnimationPlayer
onready var timer := $Timer

var playing := false

func _casting():
	if playing: return
	
	playing = true
	animation.play("CastingVenom")

func _spawnedVenom():
	animation.play("SpawnedVenom")
	timer.start()

func _on_Venom_body_entered(body):
	if body.name == "Player":
		body.playerDamage()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "CastingVenom":
		_spawnedVenom()
	if anim_name == "DissolveVenom":
		playing = false

func _on_Timer_timeout():
	animation.play("DissolveVenom")
