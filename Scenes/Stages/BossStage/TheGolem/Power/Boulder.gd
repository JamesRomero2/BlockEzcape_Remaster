extends Area2D

signal playerAffected

export(Vector2) var flyingDirection := Vector2.DOWN
export(float) var flyingSpeed := 60

onready var animation := $AnimationPlayer
onready var timer := $Timer

func _ready():
	timer.start()

func _process(delta):
	position += flyingDirection * flyingSpeed * delta

func _on_Timer_timeout():
	queue_free()

func _on_Boulder_body_entered(body):
	if body.name == "Player":
		body.playerDamage()
