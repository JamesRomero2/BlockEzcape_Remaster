extends Area2D

signal playerAffected

onready var timer := $Timer

export(Vector2) var flyingDirection := Vector2.DOWN
export(float) var flyingSpeed := 60

func _ready():
	timer.start()
	match flyingDirection:
		Vector2.UP:
			self.rotation_degrees = 0
		Vector2.DOWN:
			self.rotation_degrees = 180
		Vector2.LEFT:
			self.rotation_degrees = -90
		Vector2.RIGHT:
			self.rotation_degrees = 90
	
func _process(delta):
	position += flyingDirection * flyingSpeed * delta

func _on_Timer_timeout():
	queue_free()

func _on_Sword_body_entered(body):
	if body.name == "Player":
		body.playerDamage()
