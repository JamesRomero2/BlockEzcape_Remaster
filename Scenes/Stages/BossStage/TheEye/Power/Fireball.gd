extends Area2D

signal playerAffected

export(Vector2) var flyingDirection := Vector2.DOWN
export(float) var flyingSpeed := 60

onready var timer := $Timer

func _ready():
	timer.start()
	self.rotation_degrees = rad2deg(flyingDirection.angle()) - 90

func _on_Fireball_body_entered(body):
	if body.name == "Player":
		body.playerDamage()

func _process(delta):
	position += flyingDirection * flyingSpeed * delta

func _on_Timer_timeout():
	queue_free()
