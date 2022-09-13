extends Area2D

signal KeyCollected

onready var animation: AnimationPlayer = $AnimationPlayer

var collected: bool = false

func _ready():
	animation.play("KeyEntered")

func _on_Key_body_entered(body: Node):
	if body.name == "Player" and !collected:
		emit_signal("KeyCollected")
		print("Colelcted")
		$AnimationPlayer.play("Collected")
