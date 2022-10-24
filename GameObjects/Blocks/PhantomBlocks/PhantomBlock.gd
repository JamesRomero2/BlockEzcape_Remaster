extends StaticBody2D

onready var collisionShape := $CollisionShape2D
onready var sprite := $Sprite
onready var deathArea := $DeathArea

func _setDisableToFalse():
	sprite.visible = true
	collisionShape.set_deferred("disabled", false)
	deathArea.monitoring = true

func _setDisableToTrue():
	sprite.visible = false
	collisionShape.set_deferred("disabled", true)
	deathArea.monitoring = false

func _on_DeathArea_body_entered(body):
	if body.name == "Player":
		print("Dead")
