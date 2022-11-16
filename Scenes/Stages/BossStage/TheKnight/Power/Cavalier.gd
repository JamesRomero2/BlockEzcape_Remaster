extends Node2D

onready var anim := $AnimationPlayer

var playing := false

const sword = preload("res://Scenes/Stages/BossStage/TheKnight/Power/Sword.tscn")

func activateCavalier():
	if !playing:
		playing = true
		anim.play("Cavalier")

func throwSwords():
	for i in 4:
		var spawning = sword.instance()
		match i:
			0:
				spawning.flyingDirection = Vector2.UP
			1:
				spawning.flyingDirection = Vector2.RIGHT
			2:
				spawning.flyingDirection = Vector2.DOWN
			3:
				spawning.flyingDirection = Vector2.LEFT
			
		add_child(spawning)
		spawning.set_as_toplevel(true)
		spawning.global_position = global_position

func _on_AnimationPlayer_animation_finished(anim_name):
	playing = false
