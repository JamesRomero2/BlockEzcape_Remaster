extends Area2D

signal playerAffected

export(Vector2) var flyingDirection := Vector2.DOWN
export(float) var flyingSpeed := 60

func _process(delta):
	position += flyingDirection * flyingSpeed * delta

func _on_Boulder_body_entered(body):
	if body.name == "Player":
		body.playerDamage()
	if body.is_in_group("Stopper"):
		queue_free()
