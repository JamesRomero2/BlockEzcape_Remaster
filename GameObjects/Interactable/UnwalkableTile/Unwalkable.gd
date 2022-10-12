extends StaticBody2D

onready var collisionShape := $CollisionShape2D
onready var sprite := $Sprite

func _setDisableToFalse():
	sprite.visible = true
	collisionShape.set_deferred("disabled", false)

func _setDisableToTrue():
	sprite.visible = false
	collisionShape.set_deferred("disabled", true)
